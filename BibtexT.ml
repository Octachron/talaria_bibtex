
open Bibtex

module type Keys=
sig
	val s: string -> string -> Bibtex.entry -> Bibtex.entry
end

exception Unknown_attribute of string*string
	



let ( |>> ) database (module M:Rec.Sig with type rpr=string)=
	let f str orec= M.Repr.set orec str in
	Database.add (M.name) f database


let keydtb =
let dtb= Database.empty
	|>> (module Title)
	|>> (module Authors)
	|>> (module Journal)
	|>> (module Year)
	|>> (module Volume)
	|>> (module Number)
	|>> (module Pages)
	|>> (module Doi)
	|>> (module Arxiv)
	|>> (module Abstract)
	|>> (module State)
	|>> (module Tags)
	|>> (module Booktitle) 
	|>> (module Location)
	|>> (module Conference) 
in ref dtb


exception Unknown_attribute of string

let setAttribute key repr entry =
	try (
	let setter= Database.find key !keydtb in
	setter repr entry )
	with
		|Not_found ->  raise @@ Unknown_attribute key





let empty=Rec.empty
let data= Database.empty
	
