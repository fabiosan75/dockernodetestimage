const mongoose = require('mongoose');

const mongoURI =  'mongodb://' + 
process.env.DB_SERVICE_HOST + ':' +
process.env.DB_SERVICE_PORT + '/' +
process.env.DB_NAME;

console.log('mongoURI : ' + mongoURI);

const connectDB = async () => {
    try{
        // mongodb connection string

        const mongoURI =  'mongodb://' + 
                  process.env.DB_SERVICE_HOST + ':' +
                  process.env.DB_SERVICE_PORT + '/' +
                  process.env.DB_NAME;

         //         MONGO_URI='mongodb://localhost:27017/appadmin'
                  


        const con = await mongoose.connect(mongoURI, { // process.env.MONGO_URI
            useNewUrlParser: true,
            useUnifiedTopology: true,
            useFindAndModify: false,
            useCreateIndex: true
        })

        console.log(`MongoDB connected : ${con.connection.host} ` + mongoURI);
    }catch(err){
        console.log(err | mongoURI);
        process.exit(1);
    }
}

module.exports = connectDB