const express = require('express')
const app = express()
const port = 3001

const MongoClient = require('mongodb').MongoClient

/* Connection URL
const mongoUrl =  'mongodb://' + 
process.env.DB_SERVICE_HOST + ':' +
process.env.DB_SERVICE_PORT + '/' +
process.env.DB_NAME;
*/
const mongoUrl =  'mongodb://app_user:app_password@mongoDB:27017/test';


app.get('/', (req, res) => {
  MongoClient.connect(mongoUrl, { useNewUrlParser: true }, (err, db) => {
    if (err) {
      res.status(500).send('💥 BOOM 💥: ' + err);
    } else {
      res.send('Me conecté a la DB! 😎');
      db.close();
    }
  });
});

app.listen(port, () => console.log(`Server listening on port ${port}!`))
