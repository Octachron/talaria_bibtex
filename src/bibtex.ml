module Fields = Bibtex_fields


module Database= Fields.Database

		   
module Parser = struct
include(Parser)
let add_key key= let open Parser_aux in
		 keydtb := !keydtb |>> key
let remove_key key = let open Parser_aux in
		 let open Fields in
		 keydtb := Database.remove key.name !keydtb
end
					   
let parse=Parser.main Lexer.main 

