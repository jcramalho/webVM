var express = require('express')
var router = express.Router()
var parser = require('../controllers/VMparser')


// ------------------Tratamento dos pedidos-------
router.get('/', function(req, res, next) {
    res.render('getInput')
  })

router.get('/input', function(req, res, next) {
  res.render('getInput')
})

router.post('/compile', (req, res, next)=>{
    var parse_result = []
    try {
        parse_result = parser.parse(req.body.program)
    }
    catch(err) {
        parse_result.push(err.name) 
        parse_result.push(err.message)
    }
    
    res.json({"stack": parse_result})
})

module.exports = router;
