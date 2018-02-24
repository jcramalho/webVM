var express = require('express')
var router = express.Router()
var Lexer = require('lex')

// -------------------Questionários---------------
var lex_quest = new Lexer
var questionario = ""
lex_quest.addRule(/([eE]([uU]|[lL][eE])):/, function () {
}).addRule(/.|(\r\n)|\n/, function(lexema){
    questionario += lexema
})

// -------------------Questionários (c)-----------
var lex_quest_c = new Lexer
var questionario = ""
var eu = ""
var ele = ""
lex_quest_c.addRule(/EU=.+\./, function(lexema){
    eu = lexema.substring(3, lexema.length - 1)
}).addRule(/ELE=.+\./, function(lexema){
    ele = lexema.substring(4, lexema.length - 1)
}).addRule(/[eE][uU]:/, function (lexema) {
    questionario += eu + ": " + lexema.substring(3)
}).addRule(/[eE][lL][eE]:/, function (lexema) {
    questionario += ele + ": " + lexema.substring(4)
}).addRule(/.|(\r\n)|\n/, function(lexema){
        questionario += lexema
    })

// -------------------Abreviaturas----------------
var lex_abrev = new Lexer
var texto_abrev = ""
var novaAbrev = "", termo = ""
var abrevs = []
lex_abrev.addRule(/\\def:[a-z][a-z]+=.+;/, function(lexema){
    novaAbrev = lexema.substring(5, lexema.length - 1)
    termo = lexema.substring(11, lexema.length - 1)
    
}).addRule(/ELE=.+\./, function(lexema){
    ele = lexema.substring(4, lexema.length - 1)
}).addRule(/[eE][uU]:/, function (lexema) {
    questionario += eu + ": " + lexema.substring(3)
}).addRule(/[eE][lL][eE]:/, function (lexema) {
    questionario += ele + ": " + lexema.substring(4)
}).addRule(/.|(\r\n)|\n/, function(lexema){
        questionario += lexema
    })

// -------------------Word Count------------------
var lex_wc = new Lexer
var linhas=0, palavras=0, chars=0
lex_wc.addRule(/(\r\n)|\n/, function(){
    linhas++
    chars++
}).addRule(/\w+/, function(lexema){
    chars += lexema.length
    palavras++
}).addRule(/./, function(){
    chars++
})
// ------------------Soma on/off------------------
var lex_soma = new Lexer
var soma=0, flag=1
var strSoma = ""
lex_soma.addRule(/(\r\n)|\n/, function(){
    strSoma += "\n"
}).addRule(/=/, function(){
    strSoma += "\nSOMA: " + soma + "\n"
}).addRule(/\d+/, function(lexema){
    if(flag) soma += parseInt(lexema)
}).addRule(/!off!/, function(){
    flag = 0
}).addRule(/!on!/, function(){
    flag = 1
})
.addRule(/###/, function(){
    soma = 0
})
.addRule(/./, function(lexema){
    strSoma += lexema
})
// ------------------XML------------------
var lex_xml = new Lexer
var strText = ""
var abertura = 0
var fecho = 0
lex_xml.addRule(/(\r\n)|\n/, function(){
    strText += "\n"
}).addRule(/<[a-zA-Z0-9 "_\-]+>/, function(){
    abertura++
}).addRule(/<\/[a-zA-Z0-9= "_\-]+>/, function(){
    fecho++
}).addRule(/./, function(lexema){
    strText += lexema
})
// ------------------Tratamento dos pedidos-------
/* GET users listing. */
router.get('/input', function(req, res, next) {
  res.render('getInput')
})

router.post('/input', function(req, res, next){
    console.log(JSON.stringify(req.body))
    if(req.body.comp == "1"){
        lex_wc.setInput(req.body.intext)
        lex_wc.lex()
        var resultado = {"text":"linhas: "+linhas+", palavras: "+palavras+", chars: "+chars+"\n"}
        linhas = 0
        palavras = 0
        chars = 0
        console.log(JSON.stringify(resultado))
        res.json(resultado)
    }
    else if(req.body.comp == "2"){
        lex_soma.setInput(req.body.intext)
        lex_soma.lex()
        var resultado = {"text":strSoma}
        strSoma = ""
        soma= 0
        console.log(JSON.stringify(resultado))
        res.json(resultado)
    }
    else if(req.body.comp == "3"){
        lex_xml.setInput(req.body.intext)
        lex_xml.lex()
        var resultado = {"text": "Tags de abertura: "+abertura+", Tags de fecho: "+fecho+"\n"+strText}
        strText = ""
        abertura = 0
        fecho = 0
        console.log(JSON.stringify(resultado))
        res.json(resultado)
    }
    else if(req.body.comp == "4"){
        lex_quest.setInput(req.body.intext)
        lex_quest.lex()
        var resultado = {"text": questionario}
        questionario = ""
        res.json(resultado)
    }
    else if(req.body.comp == "5"){
        lex_quest_c.setInput(req.body.intext)
        lex_quest_c.lex()
        var resultado = {"text": questionario}
        questionario = ""
        res.json(resultado)
    }
    else
        res.json({"comp": "Unknown..."})
})

module.exports = router;
