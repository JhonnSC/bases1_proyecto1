const express = require('express')
const app = express()
const mysql = require('mysql')
const morgan = require('morgan')

app.get("/", (req,res)=> {
    console.log("root route")
    res.send("Satan")


})

app.get("/user/:id", (req,res) => {
    console.log("Buscando user con la id:" + req.params.id)
    const connection = mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: '123456',
        port: '3306',
        database: 'mydb'
    })

    connection.query("SELECT * FROM  UsersAccounts WHERE userid =1",(err,rows,fields)=>{
        console.log('Sirvio esta vara')
        res.json(rows)

    })

})

// crear 
app.listen(5000,()=> {

console.log("Server en puerto 5000")


})