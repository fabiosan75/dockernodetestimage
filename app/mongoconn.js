var mongoose = require('mongoose');
mongoose.connect('mongodb://app_user:app_password@mongoDB:27017/test', {
    
        useCreateIndex: true,
        useFindAndModify: false,
        useNewUrlParser: true
    }).then(db => console.log('conexion exitosa'))
    .catch(err => console.log('error: ', err))