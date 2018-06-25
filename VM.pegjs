{
  var SP = 0
  var Stack = []
}
Program
  = c:Command cl:(_ Command)* {return Stack}
  
Command
  = "add" _ { Stack.push(Stack.pop()+Stack.pop()); SP-- }
  / "sub" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push(op2-op1); SP-- }
  / "mul" _ { Stack.push(Stack.pop()*Stack.pop()); SP-- }
  / "div" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push(Math.floor(op2/op1)); SP-- }
  / "mod" _ { var op1=Stack.pop(); var op2=Stack.pop(); Stack.push(op2%op1); SP-- }
  / "not" _ { var top=Stack.pop(); Stack.push((top==0)?1:0); }
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
  / "pushi" _ int:Integer _ { Stack.push(int); SP++ }
  / "pushn" _ int:Integer _ { for(var i=0; i<int; i++){ Stack.push(0); SP++ } }
  / "pushf" _ f:Float _ { Stack.push(f); SP++ }
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
              