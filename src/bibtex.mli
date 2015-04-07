module Fields = Bibtex_fields

module Database = Fields.Database

module Parser : sig
include(module type of Parser)    
val add_key : 'a Fields.named_field -> unit
val remove_key : 'a Fields.named_field -> unit
end

val parse : Lexing.lexbuf -> Fields.data
