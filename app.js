const express = require('express')
const app = express()
const mysql = require('mysql2')
const morgan = require('morgan')
var bodyParser = require('body-parser')


app.use(express.static('./public'))
app.use(morgan('short'))

const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '123456',
    port: '3306',
    database: 'mydb'
})


connection.connect(err =>{
    if(err) {
        throw err
    }
    console.log('Mysql conectado')
})


app.get("/", (req,res)=> {
    console.log("root route")
    res.send("Satan")


})

app.use(express.json()) 
app.use(express.urlencoded({ extended: false }))
const router2= require("./routes/user")
const router = require("./routes/Storeprocedures")
app.use(router)
app.use(router2)


// crear 
app.listen(5000,()=> {

console.log("Server en puerto 5000")


})