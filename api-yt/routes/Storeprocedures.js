const { json } = require('express')
const express = require('express')
const router = express.Router()
const mysql = require('mysql2')
var app = express()
app.use(express.json());
const fs = require('fs');
const { sign } = require('crypto')
app.use(express.urlencoded({ extended: true })) 





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
    var nombreSP
    var argumentos
    function arreglarjson(string){
        final=0
        
        // {"PostData":"{\"nombreSP\":\"CambiosCuenta\",\"argumentos\":\"Juan,P�rez,13098\"}"}
        for(var i = 29; i < string.length; i++) {
            if (string.charAt(i)==","){
                final=i
                nombreSP=string.substring(29,final)
                nombreSP = nombreSP.substring(0,nombreSP.length-2)
            }
            if(string.charAt(i)==",") break;
        // argumentos empieza en 47+15 llego a el inicio de los argumentos
        }
        
        final=0
        for(var i = jsonstring.search('argumentos')+15; i < string.length; i++) {
            if(string.charAt(i)=='}')
            final=i
            argumentos=string.substring(jsonstring.search('argumentos')+15,final)
            argumentos = argumentos.substring(0,argumentos.length-4)
            
        
        
        
        }
    
    
    
    }
    


    app.use(express.json());
    console.log("Usando un SP") 
    //argumentos = req.body.argumentos
    //nombreSP = req.body.nombreSP
    //console.log(req.body)
    
    var inputap = req.body // inputcap se le pasa el json string 
    console.log('json parse')
    var jsonstring = JSON.stringify(inputap) // paso el json string a un string
    console.log('pruebas demasiadas pruebas')
    arreglarjson(jsonstring)
    console.log(nombreSP)
    console.log(argumentos)

    
    
    separar(argumentos)

    

 // inicia en 






    
    if(nombreSP== 'obtenerPlan'){
        connection.query('call obtenerPlan(?,?,?,?,?,?,?,?)',[[matriz[0]],[matriz[1]],[matriz[2]],[matriz[3]],[matriz[4]],[matriz[5]],[matriz[6]],[matriz[7]]],(err,results,fields)=>{     
            if(err){
                console.log('Failed to query'+ err)
                res.sendStatus(500)
            
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
              
                return 

            }
            console.log('Sirvio esta vara')
            console.log(results)
            res.json("Hola")
        })
    
    }
    if(nombreSP== 'InsertarFotosUsuarios'){
        connection.query('call InsertarFotosUsuarios(?,?)',[[matriz[0]],[matriz[1]]],(err,results,fields)=>{     
            if(err){
                console.log('Failed to query'+ err)
                res.sendStatus(500)
              
                return 

            }
            console.log('Sirvio esta vara')
            console.log(results)
            
            res.json("Hola")
        })
    
    }
    if(nombreSP== 'IdiomaPlanes'){
        connection.query('call IdiomaPlanes(?)',[[matriz[0]]],(err,results,fields)=>{     
            if(err){
                console.log('Failed to query'+ err)
                res.sendStatus(500)
              
                return 

            }
            console.log('Sirvio esta vara')
            console.log(results)
            
            res.json("Hola")
        })
        
    }
    if(nombreSP== 'IdiomaIntereses'){
        connection.query('call IdiomaIntereses(?)',[[matriz[0]]],(err,results,fields)=>{     
            if(err){
                console.log('Failed to query'+ err)
                res.sendStatus(500)
              
                return 

            }
            console.log('Sirvio esta vara')
            console.log(results)
            
            res.json("Hola")
        })
        
    }
    if(nombreSP== 'VerUsoPlanes'){
        connection.query('call VerUsoPlanes(?)',[[matriz[0]]],(err,results,fields)=>{     
            if(err){
                console.log('Failed to query'+ err)
                res.sendStatus(500)
              
                return 

            }
            console.log('Sirvio esta vara')
            console.log(results)
            
            res.json("Hola")
        })
        
    }
    if(nombreSP== 'VerPagos'){
        connection.query('call VerPagos(?)',[[matriz[0]]],(err,results,fields)=>{     
            if(err){
                console.log('Failed to query'+ err)
                res.sendStatus(500)
              
                return 

            }
            console.log('Sirvio esta vara')
            console.log(results)
            
            res.json("Hola")
        })
        
    }

    if(nombreSP== 'likes'){
        connection.query('call likes(?,?,?,?,?)',[[matriz[0]],[matriz[1]],[matriz[2]],[matriz[3]],[matriz[4]]],(err,results,fields)=>{     
            if(err){
                console.log('Failed to query'+ err)
                res.sendStatus(500)
              
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