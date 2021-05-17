const { json } = require('express')
const express = require('express')
const router = express.Router()
const mysql = require('mysql2')
var app = express()
app.use(express.json());
var matriz = []
function separar(str){
    var inicio= 0
    var final= 0
    var contador=0
    for(var i = 0; i < str.length; i++) {
        if (str.charAt(i) == ','){
            final = i
            matriz[contador] = str.substring(inicio,final)
            inicio=final+1
            contador++
        }
        if(i==str.length-1){
            final = i
            matriz[contador] = str.substring(inicio,final+1)
            inicio=final+1
            contador++
        }
    }
}


 
router.post("/storedprocedures", (req,res) => {
    console.log("Usando un SP") 

    app.use(express.json());
    var nombreSP = ''
    var argumentos = ''
    nombreSP = req.body.nombreSP;
    argumentos = req.body.argumentos;
    console.log(nombreSP)
    console.log(req.body.argumentos)
    
    separar(argumentos)


    
    if(nombreSP== 'obtenerPlan'){
        connection.query('call obtenerPlan(?,?,?,?,?,?,?,?)',[[matriz[0]],[matriz[1]],[matriz[2]],[matriz[3]],[matriz[4]],[matriz[5]],[matriz[6]],[matriz[7]]],(err,results,fields)=>{     
            if(err){
                console.log('Failed to query'+ err)
                res.sendStatus(500)
                connection.end()
                return 

            }
            console.log('Sirvio esta vara')
            console.log(results)
            res.json("Hola")
        })
        
    }

    if(nombreSP== 'CambiosCuenta'){
        connection.query('call CambiosCuenta(?,?,?)',[[matriz[0]],[matriz[1]],[matriz[2]]],(err,results,fields)=>{     
            if(err){
                console.log('Failed to query'+ err)
                res.sendStatus(500)
                connection.end()
                return 

            }
            console.log('Sirvio esta vara')
            console.log(results)
            res.json("Hola")
        })
        
    }



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