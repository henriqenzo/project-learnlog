const mongoose = require('mongoose');
require('dotenv').config();

const connectMongo = async () => {
    try {
        const uri = process.env.MONGO_URI || 'mongodb://localhost:27017/learnlog_nosql';
        
        await mongoose.connect(uri);
        console.log('🍃 MongoDB conectado com sucesso!');
    } catch (error) {
        console.error('Erro ao conectar no MongoDB:', error);
    }
};

module.exports = connectMongo;