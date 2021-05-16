const express = require('express')
const router = express.Router()
const mysql = require('mysql2')




router.get("/sp", (req,res) => {
    console.log("Usando el SP obtenerPlan")
    var plan = '5000,colones,1234,PlanPremium1.0(Mensual),Juan,Pérez,Paypal,Débito' 
    const primero = '5000' 
    const segundo = 'colones' 
    const tercer =  '1234' 
    const  cuarto =  'Plan Premium 1.0 (Mensual)'
    const quinto = 'Juan'
    const sexto = 'Pérez'
    const septimo = 'Paypal'
    const octavo = 'Débito'
    
    function countWords(str) {
        return str.trim().split(/\s+/).length;
      }
    function splitStr(str) {
      
        // Function to split string
      
        var string = str.split(",");
          
        console.log(string);
    }
  
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

separar(plan)
console.log(matriz[0])
console.log(matriz[1])
console.log(matriz[2])
console.log(matriz[3])
console.log(matriz[4])
console.log(matriz[5])
console.log(matriz[6])
console.log(matriz[7])

    connection.query('call obtenerPlan(?,?,?,?,?,?,?,?)',[matriz[0],matriz[1],matriz[2],matriz[3],matriz[4],matriz[5],matriz[6],matriz[7]],(err,rows,fields)=>{
        if(err){
            console.log('Failed to query'+ err)
            res.sendStatus(500)
            return 

        }
        
        
        console.log('Sirvio esta vara')
    })
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