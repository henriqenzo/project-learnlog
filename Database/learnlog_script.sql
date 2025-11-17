
DROP DATABASE IF EXISTS learnlog_db;
CREATE DATABASE learnlog_db;
USE learnlog_db;


-- TABELAS

-- Tabela Obrigatória: Grupos de Usuários
CREATE TABLE grupos_usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT, -- Auto_increment pois são poucos registros fixos
    nome_grupo VARCHAR(50) NOT NULL UNIQUE, 
    descricao VARCHAR(255)
);

-- Inserção de Grupos Padrão
INSERT INTO grupos_usuarios (nome_grupo, descricao) VALUES 
('ADMIN', 'Acesso total ao sistema e relatórios'),
('ALUNO', 'Acesso aos cursos e material didático');

-- Tabela Obrigatória: Usuários
CREATE TABLE usuarios (
    id VARCHAR(10) PRIMARY KEY, -- ID Gerado via Função
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    id_grupo INT NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_grupo) REFERENCES grupos_usuarios(id)
);

-- Tabela: Cursos
CREATE TABLE cursos (
    id VARCHAR(10) PRIMARY KEY, -- ID Gerado via Função
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) DEFAULT 0.00,
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela: Matrículas (Relacionamento N:N entre Usuários e Cursos)
CREATE TABLE matriculas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario VARCHAR(10),
    id_curso VARCHAR(10),
    data_matricula DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (id_curso) REFERENCES cursos(id) ON DELETE CASCADE,
    UNIQUE(id_usuario, id_curso)
);

-- Tabela Auxiliar: Log de Auditoria 
CREATE TABLE logs_sistema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    acao VARCHAR(50),
    detalhe TEXT,
    data_log DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- ÍNDICES

-- 1. Índice em Email
CREATE INDEX idx_usuario_email ON usuarios(email);

-- 2. Índice em Título do Curso
CREATE INDEX idx_curso_titulo ON cursos(titulo);


-- FUNCTIONS 

DELIMITER $$

-- Function 1: Gera ID para Usuários (Ex: USR-492)
CREATE FUNCTION fn_gerar_id_usuario() RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE novo_id VARCHAR(10);
    SET novo_id = CONCAT('USR-', FLOOR(1000 + (RAND() * 8999))); 
    RETURN novo_id;
END$$

-- Function 2: Gera ID para Cursos (Ex: CRS-101)
CREATE FUNCTION fn_gerar_id_curso() RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE novo_id VARCHAR(10);
    SET novo_id = CONCAT('CRS-', FLOOR(100 + (RAND() * 900))); 
    RETURN novo_id;
END$$

DELIMITER ;


-- PROCEDURES (Regras de Negócio)

DELIMITER $$

-- Procedure 1: Criar Usuário Seguro
CREATE PROCEDURE sp_criar_usuario(
    IN p_nome VARCHAR(100), 
    IN p_email VARCHAR(100), 
    IN p_senha VARCHAR(255),
    IN p_id_grupo INT
)
BEGIN
    DECLARE v_id VARCHAR(10);
    SET v_id = fn_gerar_id_usuario(); -- Usa a Function 1
    
    INSERT INTO usuarios (id, nome, email, senha_hash, id_grupo) 
    VALUES (v_id, p_nome, p_email, p_senha, p_id_grupo);
END$$

-- Procedure 2: Criar Curso Novo
CREATE PROCEDURE sp_criar_curso(
    IN p_titulo VARCHAR(150),
    IN p_descricao TEXT,
    IN p_preco DECIMAL(10,2)
)
BEGIN
    DECLARE v_id VARCHAR(10);
    SET v_id = fn_gerar_id_curso(); -- Usa a Function 2
    
    INSERT INTO cursos (id, titulo, descricao, preco)
    VALUES (v_id, p_titulo, p_descricao, p_preco);
END$$

DELIMITER ;


-- TRIGGERS

DELIMITER $$

-- Trigger 1: Auditoria de Alteração de Preço
CREATE TRIGGER trg_audit_preco_curso
AFTER UPDATE ON cursos
FOR EACH ROW
BEGIN
    IF OLD.preco <> NEW.preco THEN
        INSERT INTO logs_sistema (acao, detalhe)
        VALUES ('UPDATE_PRECO', CONCAT('Curso ', OLD.id, ' alterado de ', OLD.preco, ' para ', NEW.preco));
    END IF;
END$$

-- Trigger 2: Proteção do Grupo ADMIN
CREATE TRIGGER trg_protecao_grupo_admin
BEFORE DELETE ON grupos_usuarios
FOR EACH ROW
BEGIN
    IF OLD.nome_grupo = 'ADMIN' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'ERRO: Não é permitido excluir o grupo ADMIN.';
    END IF;
END$$

DELIMITER ;


-- VIEWS 

-- View 1: Relatório de Perfil
CREATE VIEW view_perfil_usuario AS
SELECT u.id, u.nome, u.email, u.data_cadastro, g.nome_grupo, g.descricao as descricao_funcao
FROM usuarios u
JOIN grupos_usuarios g ON u.id_grupo = g.id;

-- View 2: Catálogo de Cursos Simples
CREATE VIEW view_catalogo_cursos AS
SELECT id, titulo, descricao, preco
FROM cursos
WHERE ativo = TRUE;


-- CONTROLE DE ACESSO (USERS & ROLES)

-- 1. Usuário da API (O que a API vai usar)
-- Acesso: Apenas CRUD nas tabelas necessárias e execução de procedures.
DROP USER IF EXISTS 'learnlog_api'@'localhost';
CREATE USER 'learnlog_api'@'localhost' IDENTIFIED BY 'ApiPass123!';
GRANT SELECT, INSERT, UPDATE, DELETE ON learnlog_db.* TO 'learnlog_api'@'localhost';
GRANT EXECUTE ON PROCEDURE learnlog_db.sp_criar_usuario TO 'learnlog_api'@'localhost';
GRANT EXECUTE ON PROCEDURE learnlog_db.sp_criar_curso TO 'learnlog_api'@'localhost';

-- 2. Usuário Auditor (Apenas Leitura)
-- Acesso: Apenas SELECT, ideal para geração de relatórios ou backup.
DROP USER IF EXISTS 'learnlog_auditor'@'localhost';
CREATE USER 'learnlog_auditor'@'localhost' IDENTIFIED BY 'AuditPass123!';
GRANT SELECT ON learnlog_db.* TO 'learnlog_auditor'@'localhost';

FLUSH PRIVILEGES;


-- DADOS DE TESTE (SEED)

-- Criando usuários via Procedure
CALL sp_criar_usuario('Admin Master', 'admin@learnlog.com', 'hash_secreto', 1);
CALL sp_criar_usuario('João Aluno', 'joao@gmail.com', '123456', 2);

-- Criando cursos via Procedure
CALL sp_criar_curso('Introdução ao Swift', 'Curso básico de iOS', 0.00);
CALL sp_criar_curso('Banco de Dados Avançado', 'MySQL e NoSQL na prática', 99.90);
CALL sp_criar_curso('NodeJS API Rest', 'Backend escalável', 49.90);

-- Simulando uma matrícula manual
INSERT INTO matriculas (id_usuario, id_curso)
SELECT u.id, c.id FROM usuarios u, cursos c 
WHERE u.email = 'joao@gmail.com' AND c.titulo LIKE 'Introdução ao Swift%';