(** Predefined bibtex fields and helper functions. *)

include Field_types.self


(** Talaria-bibtex exposes its own [orec] namespace
    @closed *)
include Orec.Namespace.S [@@odoc.inline off]

(** A bibtex field consists of an [orec] field, a name and a
    translation between the raw text of the field towards a typed field
*)
type 'a named_field = {name : string; f:'a field; conv:('a,string) bijection }

(** The exception {Unknown_attribute} is raised whenever a type dkey fails to parse
    its contents to its underlying type.
*)
exception Unknown_attribute of string * string

(** Create a string view from a {!type-named_field} *)
val str : 'a named_field -> string field

(** Field creation helper *)
val named_field : name:string -> ('a, string) bijection -> 'a named_field

(** {1:predefined_field_kind Predefined field kind} *)

val str_field : name:string -> string named_field
val int_field : name:string -> int named_field
module StrSet : Set.S with type elt = string
module Database : Map.S with type key = string
val strset_field : name:string -> StrSet.t named_field

(** {1:field_list List of predefined fields } *)

val uid : string named_field
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

(* This is the key entry for untyped keys: all key entry that cannot fit a
    known typed key are recorded inside the {!Database.t} map  *)
val raw : string Database.t field


(** The default typed keys when parsing bibtex file *)
val default_keys : string field Database.t


(** {1:direct_fields Direct access functions} *)

(** Both {!val-uid} and {!val-kind} are compulsory *)
val get_uid : t -> string
val get_kind : t -> kind

(** {!val-state} default to {!WIP} when the field is absent *)
val get_state : t -> state

(** Type alias *)
type entry = t
type data = entry Database.t

(** {1:raw_database Raw database and entries } *)
type raw_entry = { uid:string; kind:string; raw: string Database.t  }
val check: ?with_keys: string field Database.t -> raw_entry Database.t -> data
