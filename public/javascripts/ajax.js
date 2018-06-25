function prettyCode(p, pc){
    var res = ""
    for(var i=0; i<pc; i++){
        res += '<div id="line' + (i+1) + '">' + (i+1) + " " + p[i] + "</div>\n"
    }
    return res
}

$(function(){
    var PC = 0
    var program = []

    $("#intext").val("")
    $("#proc").click(function(){
      var textSource = {"comp": $("#comp").val(),"intext": $("#intext").val()}
      $.ajax({
          type: 'POST',
          data: textSource,
          url: '/compilers/input',
          dataType: 'JSON'
      }).done(function(response){
        var html = "<pre>" + response.text + "</pre>"
        $("#resultado").append(html)
      })
    })

    $("#limpa").click(function(){
        $("#resultado").children().remove()
    })

    $("#novo").click(function(){
        $("#intext").val("")
    })

    $("#codeline").change(function() {
        PC++
        program.push($("#codeline").val())
        $("#incode").html(prettyCode(program, PC))
        $("#codeline").val("")
        $.ajax({
            type: 'POST',
            data: {"program": program.join('\n')},
            url: '/compile',
            dataType: 'JSON'
        }).done(function(response){
            var html = "<pre>" + JSON.stringify(response) + "</pre>"
            $("#resultado").append(html)
        })
    })
})


    