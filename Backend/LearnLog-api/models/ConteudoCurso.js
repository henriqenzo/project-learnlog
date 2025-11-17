const mongoose = require('mongoose');

const LicaoSchema = new mongoose.Schema({
    titulo: String,
    tipo: { type: String, enum: ['VIDEO', 'TEXTO', 'QUIZ'] },
    url_video: String, // Só existe se for vídeo
    texto_conteudo: String, // Só existe se for texto
    duracao_minutos: Number
});

const ConteudoCursoSchema = new mongoose.Schema({
    id_curso_sql: { type: String, required: true, unique: true },
    licoes: [LicaoSchema], 
    ultima_atualizacao: { type: Date, default: Date.now }
});

module.exports = mongoose.model('ConteudoCurso', ConteudoCursoSchema);