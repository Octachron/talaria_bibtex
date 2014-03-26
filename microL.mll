{
open MicroP
}



let ops = [',' '-']
let nops = [^ ',' '-']
let num=['0'-'9']
let space= [' ' '\t']
let bnops=nops # space
let nnum = nops # num

let nsep= [^ '/']

rule pages=parse
| space {pages lexbuf}
| nnum+ as s { WORD s }
| num+ as n { NUM(int_of_string n)} 
| '-' { MINUS }
| eof {EOF}


and names= parse
| space { names lexbuf }
| ',' { COMMA }
| bnops+ as s { match s with
			| "and" -> AND
			| s -> WORD s 
}
| eof {EOF}

and tags = parse
| space { tags lexbuf }
| ',' { COMMA }
| bnops [^ ',']* as s { WORD s }
| eof {EOF}

and path= parse
| '/' {SEP}
| nsep+ as s {WORD s}
| eof {EOF}
