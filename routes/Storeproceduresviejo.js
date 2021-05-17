const express = require('express')
const router = express.Router()
const mysql = require('mysql2')
var app = express()
app.use(express.json()) 
app.use(express.urlencoded({ extended: false }))    

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

console.log("Usando un SP") 
console.log("Usando un SP") 
router.get("/usar_sp", (req,res) => {
    console.log("Entro") 
    //var plan = '5000,colones,1234,Plan_Premium_2.0_(Mensual),Mónica,Guillamon,Paypal,Débito'   
   var storeprocedure = ''
   var argumentos = ''
    console.log("3")
    console.log('1')
    console.log(storeprocedure)
    console.log('2')
    separar(argumentos)
    storeprocedure = req.body.nombreSP
    argumentos = req.body.argumentos
    //console.log(matriz[0])
    //console.log(matriz[1])
    //console.log(matriz[2])
    //console.log(matriz[3])
    //console.log(matriz[4])
    //console.log(matriz[5])
    //console.log(matriz[6])
    //console.log(matriz[7])
    
    //connection.query('call obtenerPlan(?,?,?,?,?,?,?,?)',[[matriz[0]],[matriz[1]],[matriz[2]],[matriz[3]],[matriz[4]],[matriz[5]],[matriz[6]],[matriz[7]]],(err,results,fields)=>{    
    if(storeprocedure== 'obtenerPlan'){
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
        connection.end()
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