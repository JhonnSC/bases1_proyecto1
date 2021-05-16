const express = require('express')
const router = express.Router()
const mysql = require('mysql2')


router.post("/user/:userid", (req,res) => {
    console.log("Buscando user con la id:" + req.params.userid)
    const userId = req.params.id
    const queryString = 'SELECT * FROM UsersAccounts WHERE userid = 1'


    

    connection.query(queryString, [[userId]] ,(err,rows,fields)=>{
        if(err){
            console.log('Failed to query'+ err)
            res.sendStatus(500)
            return 

        }
        
        const users = rows.map((row)=>{
            return {userID: row.userid, nombre: row.nombre, apellido1: row.apellido1, username: row.username, email: row.email}
        })
        res.json(users)
        })
        
        console.log('Sirvio esta vara')
        

})

module.exports = router
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