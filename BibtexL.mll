{
open BibtexP
}

let ops = ['{' '}' ',' '=']
let nops = [^ '{' '}' ',' '=']
let space= [' ' '\t']
let bnops=nops # space # ['\n']

rule main= parse
| space {main lexbuf} 
| '{'  { LCURL }
| '}'  { RCURL }
| '='  { EQUAL }
|  '\n'  { Lexing.new_line lexbuf; main lexbuf}
| ',' { COMMA }
(*| "and"  {AND} *)
| '@'(nops+ as s)  {KIND s}
| (bnops nops*) as s  { TEXT s }
| eof {EOF}
