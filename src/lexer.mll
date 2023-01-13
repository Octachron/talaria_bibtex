{
open Parser
}

let ops = ['{' '}' ',' '=']
let space= [' ' '\t']
let nops = [^ '{' '}' ',' '=']
let bnops=nops # space # ['\n']

rule main= parse
| space {main lexbuf} 
| '{'  { LCURL }
| '}'  { RCURL }
| '='  { EQUAL }
|  '\n'  { Lexing.new_line lexbuf; main lexbuf}
| ',' { COMMA }
| '@'(nops+ as s)  {KIND s}
| (bnops nops*) as s  { TEXT s }
| eof {EOF}
