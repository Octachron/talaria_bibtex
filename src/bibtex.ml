module Fields = Bibtex_fields


module Database= Fields.Database

		   
module Parser = struct
include(Parser)
let add_field key= let open Parser_aux in
		 keydtb := !keydtb |>> key
let remove_field key = let open Parser_aux in
		 let open Fields in
		 keydtb := Database.remove key.name !keydtb
end
					   
let parse=Parser.main Lexer.main 

module MicroP = MicroP
module MicroL=MicroL
module Lexer=Lexer
