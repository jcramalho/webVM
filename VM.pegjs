{
  var line = 0
  // Registos
  var SP = 0
  var FP = 0
  var GP = 0
  var PC = 0
  // Estruturas
  var Stack = []
  var callStack = []
  var strHeap = []
  var blockHeap = []
  var Memory = []
  var errorList = []
}
Program
  = c:Command cl:(_ Command)* {return {s: Stack, e: errorList, m: Memory}}
  
Command
  = "add" _ { line++
              var op1 = Stack.pop()
              var op2 = Stack.pop()
              if((op1.type != "integer")||(op2.type != "integer")){
                errorList.push("Error line " + line + ": add - trying to add non integer!")
                Stack.push({type: "unknown", value: op1.value + op2.value})
              } 
              else{
                Stack.push({type: "integer", value: op1.value + op2.value})
              }
              SP-- 
              Memory.push({inst: "add"}) }
  / "sub" _ { line++
              var op1 = Stack.pop()
              var op2 = Stack.pop()
              if((op1.type != "integer")||(op2.type != "integer")){
                errorList.push("Error line " + line + ": sub - trying to subtract non integer!")
                Stack.push({type: "unknown", value: op2.value - op1.value})
              } 
              else{
                Stack.push({type: "integer", value: op2.value - op1.value})
              }
              SP-- 
              Memory.push({inst: "sub"}) }
  / "mul" _ { line++
              var op1 = Stack.pop()
              var op2 = Stack.pop()
              if((op1.type != "integer")||(op2.type != "integer")){
                errorList.push("Error line " + line + ": mul - trying to multiply non integer!")
                Stack.push({type: "unknown", value: op1.value * op2.value})
              } 
              else{
                Stack.push({type: "integer", value: op1.value * op2.value})
              }
              SP-- 
              Memory.push({inst: "mul"}) }
  / "div" _ { line++
              var op1 = Stack.pop()
              var op2 = Stack.pop()
              if((op1.type != "integer")||(op2.type != "integer")){
                errorList.push("Error line " + line + ": div - trying to divide non integer!")
                Stack.push({type: "integer", value: Math.floor(op2.value / op1.value)})
              } 
              else{
                Stack.push({type: "integer", value: Math.floor(op2.value / op1.value)})
              }
              SP-- 
              Memory.push({inst: "div"}) }
  / "mod" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push(op2%op1); SP-- }
  / "not" _ { line++
              var top=Stack.pop()
              if(top.type != "integer"){
                errorList.push("Error line " + line + ": not - trying to negate non integer!")
              } 
              Stack.push({type: "boolean", value: (top.value==0?1:0)}) }
  / "inf" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push((op2<op1)?1:0); SP-- }
  / "infeq" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push((op2<=op1)?1:0); SP-- }
  / "sup" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push((op2>op1)?1:0); SP-- }
  / "supeq" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push((op2>=op1)?1:0); SP-- }
  / "fadd" _ { Stack.push(Stack.pop()+Stack.pop()); SP-- }
  / "fsub" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push(op2-op1); SP-- }
  / "fmul" _ { Stack.push(Stack.pop()*Stack.pop()); SP-- }
  / "fdiv" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push(op2/op1); SP-- }
  / "fcos" _ { var top=Stack.pop(); Stack.push(Math.cos(top)) }
  / "fsin" _ { var top=Stack.pop(); Stack.push(Math.sin(top)) }
  / "finf" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push((op2<op1)?1:0); SP-- }
  / "finfeq" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push((op2<=op1)?1:0); SP-- }
  / "fsup" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push((op2>op1)?1:0); SP-- }
  / "fsupeq" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push((op2>=op1)?1:0); SP-- }
  / "padd" _ { Stack.push(Stack.pop()+Stack.pop()); SP-- }
  / "equal" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push((op2==op1)?1:0); SP-- }
  / "pushi" _ int:Integer _ { Stack.push({type: "integer", value: int}); 
                              SP++; 
                              Memory.push({inst: "pushi", arg1: int})
                              line++ }
  / "pushn" _ int:Integer _ { for(var i=0; i<int; i++){ Stack.push(0); SP++ } }
  / "pushf" _ f:Float _ { Stack.push({type: "float", value: f})
                          SP++
                          Memory.push({inst: "pushf", arg1: f}) 
                          line++ }
  / "pop" _ int:Integer _ { for(var i=0; i<int; i++){ Stack.pop(); SP-- } }
  / "popn" _ { var top=stack.pop(); SP--; for(var i=0; i<top; i++){ Stack.pop(); SP-- } }
  / "storeg" _ int:Integer _ { Stack[int] = Stack[--SP] }
  / "pushg" _ int:Integer _ { Stack.push(Stack[int]); SP++ }
  / "swap" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push(op1); Stack.push(op2) }

Float "float"
    = [0-9]+ "." [0-9]+ { return parseFloat(text()) }

Integer "integer"
  = _ [0-9]+ { return parseInt(text(), 10); }

_ "whitespace"
  = [ \t\n\r]*
              