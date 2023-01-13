module Fields = Fields

module Database = Fields.Database

module Parser : sig
include(module type of Parser)
val add_field : 'a Fields.named_field -> unit
val remove_field : 'a Fields.named_field -> unit
end

val parse : Lexing.lexbuf -> Fields.data

module MicroP=MicroP
module MicroL=MicroL
module Lexer=Lexer
