const express = require('express');
const cors = require('cors');
const db = require('./db');
const connectMongo = require('./mongo');
const ConteudoCurso = require('./models/ConteudoCurso');
connectMongo(); 

const app = express();
app.use(express.json());
app.use(cors());


app.get('/api/cursos', async (req, res) => {
    try {
        // Usando a view criada no banco!
        const [rows] = await db.query('SELECT * FROM view_catalogo_cursos');
        res.json(rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erro ao buscar dados no MySQL' });
    }
});

app.get('/api/cursos/:id', async (req, res) => {
    const cursoId = req.params.id;

    try {
        // 1. Busca no MySQL (Dados relacionais)
        const [rows] = await db.query('SELECT * FROM view_catalogo_cursos WHERE id = ?', [cursoId]);
        const cursoMySQL = rows[0];

        if (!cursoMySQL) {
            return res.status(404).json({ error: 'Curso não encontrado no MySQL' });
        }

        // 2. Busca no MongoDB (Conteúdo não estruturado)
        const conteudoMongo = await ConteudoCurso.findOne({ id_curso_sql: cursoId });

        // 3. Junta os resultados
        const respostaCompleta = {
            ...cursoMySQL, // Título, Preço, Descrição
            aulas: conteudoMongo ? conteudoMongo.licoes : [] // Lista de Aulas (ou vazio se não tiver)
        };

        res.json(respostaCompleta);

    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erro ao buscar detalhes do curso' });
    }
});

app.post('/api/login', async (req, res) => {
    const { email, senha } = req.body;

    try {
        const query = `
            SELECT u.id, u.nome, u.email, g.nome_grupo 
            FROM usuarios u 
            JOIN grupos_usuarios g ON u.id_grupo = g.id 
            WHERE u.email = ? AND u.senha_hash = ?
        `;

        const [rows] = await db.query(query, [email, senha]);

        if (rows.length > 0) {
            const user = rows[0];
            res.json({
                success: true,
                user: {
                    id: user.id,
                    name: user.nome,
                    email: user.email,
                    role: user.nome_grupo // 'ALUNO' ou 'ADMIN'
                }
            });
        } else {
            res.status(401).json({ success: false, message: 'Credenciais inválidas' });
        }

    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erro interno no servidor' });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Servidor rodando na porta ${PORT}`);
});