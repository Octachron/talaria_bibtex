
include (module type of MicroT)
	  
exception Unknown_attribute of string * string
include module type of Orec.Namespace()
type 'a named_field = {name : string; f:'a field; conv:('a,string) bijection }
	 
(** Create a string view from a named_field *)		  
val str : 'a named_field -> string field

(** Field creation helper *)
val named_field : ('a, string) bijection -> string -> 'a named_field
val str_field : string -> string named_field
val int_field : string -> int named_field
module StrSet : Set.S with type elt = string
module Database : Map.S with type key = string
val strset_field : string -> StrSet.t named_field

(** Field list *)
val uid : string named_field
val raw : string Database.t field
val kind : kind named_field
val title : string named_field
val authors : name list named_field
val year : int named_field
val journal : string named_field
val booktitle : string named_field
val volume : int named_field
val number : int named_field
val pages : pages named_field
val doi : string list named_field
val arxiv : string named_field
val tags : StrSet.t named_field
val src : StrSet.t named_field
val state : state named_field
val abstract : string named_field
val location : string named_field
val conference : string named_field
			
(** Direct access function for compulsory field *)			
val get_uid : t -> string
val get_kind : t -> kind

(** Direct access function for field with a meaningful default value *)
val get_state : t -> state

(** Type alias *)			      
type entry = t
type data = entry Database.t
