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
router.post("/usar_sp", (req,res) => {
    console.log("Entro") 
    //var plan = '5000,colones,1234,Plan_Premium_2.0_(Mensual),Mónica,Guillamon,Paypal,Débito'   
   var storeprocedure = ''
   var argumentos = ''
    console.log(storeprocedure)
    storeprocedure = req.body.nombreSP
    argumentos = req.body.argumentos
    separar(argumentos)
    
    
    console.log(matriz[0])
    console.log(matriz[1])
    console.log(matriz[2])
    console.log(matriz[3])
    console.log(matriz[4])

    
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
            res.json("SP ejecutado con exito")
        })
        connection.end()
    }


if(storeprocedure== 'CambiosCuenta'){
    connection.query('call CambiosCuenta(?,?,?)',[[matriz[0]],[matriz[1]],[matriz[2]]],(err,results,fields)=>{     
        if(err){
            console.log('Failed to query'+ err)
            res.sendStatus(500)
          
            return 

        }
        console.log('Sirvio esta vara')
        console.log(results)
        res.json("SP ejecutado con exito")
    })

}
if(storeprocedure== 'InsertarFotosUsuarios'){
    connection.query('call InsertarFotosUsuarios(?,?)',[[matriz[0]],[matriz[1]]],(err,results,fields)=>{     
        if(err){
            console.log('Failed to query'+ err)
            res.sendStatus(500)
          
            return 

        }
        console.log('Sirvio esta vara')
        console.log(results)
        
        res.json("SP ejecutado con exito")
    })

}
if(storeprocedure== 'IdiomaPlanes'){
    connection.query('call IdiomaPlanes(?)',[[matriz[0]]],(err,results,fields)=>{     
        if(err){
            console.log('Failed to query'+ err)
            res.sendStatus(500)
          
            return 

        }
        console.log('Sirvio esta vara')
        console.log(results)
        
        res.json("SP ejecutado con exito")
    })
    
}
if(storeprocedure== 'IdiomaIntereses'){
    connection.query('call IdiomaIntereses(?)',[[matriz[0]]],(err,results,fields)=>{     
        if(err){
            console.log('Failed to query'+ err)
            res.sendStatus(500)
          
            return 

        }
        console.log('Sirvio esta vara')
        console.log(results)
        
        res.json("SP ejecutado con exito")
    })
    
}
if(storeprocedure== 'VerUsoPlanes'){
    connection.query('call VerUsoPlanes(?)',[[matriz[0]]],(err,results,fields)=>{     
        if(err){
            console.log('Failed to query'+ err)
            res.sendStatus(500)
          
            return 

        }
        console.log('Sirvio esta vara')
        console.log(results)
        
        res.json("SP ejecutado con exito")
    })
    
}
if(storeprocedure== 'VerPagos'){
    connection.query('call VerPagos(?)',[[matriz[0]]],(err,results,fields)=>{     
        if(err){
            console.log('Failed to query'+ err)
            res.sendStatus(500)
          
            return 

        }
        console.log('Sirvio esta vara')
        console.log(results)
        
        res.json("SP ejecutado con exito")
    })
    
}

if(storeprocedure== 'likes'){
    connection.query('call likes(?,?,?,?,?)',[[matriz[0]],[matriz[1]],[matriz[2]],[matriz[3]],[matriz[4]]],(err,results,fields)=>{     
        if(err){
            console.log('Failed to query'+ err)
            res.sendStatus(500)
          
            return 

        }
        console.log('Sirvio esta vara')
        console.log(results)
        res.json("SP ejecutado con exito")
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