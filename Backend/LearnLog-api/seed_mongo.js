const mongoose = require('mongoose');
const ConteudoCurso = require('./models/ConteudoCurso');
const connectMongo = require('./mongo');

const ID_DO_SEU_CURSO = 'CRS-474'; 

const seed = async () => {
    await connectMongo();

    const novoConteudo = new ConteudoCurso({
        id_curso_sql: ID_DO_SEU_CURSO,
        licoes: [
            {
                titulo: "Boas vindas",
                tipo: "TEXTO",
                texto_conteudo: "Parabéns por entrar no curso! Vamos começar.",
                duracao_minutos: 2
            },
            {
                titulo: "Instalando as ferramentas",
                tipo: "VIDEO",
                url_video: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                duracao_minutos: 10
            }
        ]
    });

    try {
        await novoConteudo.save();
        console.log("Conteúdo inserido no MongoDB!");
    } catch (e) {
        console.log("Erro (talvez já exista conteúdo para este ID):", e.message);
    }
    process.exit();
};

seed();