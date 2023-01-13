open Bibtex
let fp =Format.fprintf
let p = Format.printf
let string = Format.pp_print_string
let int = Format.pp_print_int

module Scan_test = struct
  [@@@warning "-unused-value-declaration"]

  let rec scanp ppf lexb= match MicroL.pages lexb with
	| MicroP.EOF -> fp ppf "EOF \n"
	| MicroP.NUM(n) -> fp ppf "Num(%d)" n; scanp ppf lexb
	| MicroP.MINUS -> fp ppf "<->"; scanp ppf lexb
	| MicroP.WORD(s)-> fp ppf "WORD(%s)\n" s; scanp ppf lexb
	| MicroP.COMMA -> fp ppf "<,>"
	| MicroP.AND -> fp ppf "<and>"
	| MicroP.SEP -> fp ppf "</>"; scanp ppf lexb



  let rec scan ppf lexbuf= match Lexer.main lexbuf with
	| EOF -> fp ppf "EOF \n"
	| TEXT(s) -> fp ppf "text: \"%s\" \n" s ; scan ppf lexbuf
	| LCURL -> fp ppf "<" ; scan ppf lexbuf
	| RCURL -> fp ppf ">"; scan ppf lexbuf
	| COMMA -> fp ppf ":,:"; scan ppf lexbuf
	| KIND s-> fp ppf "Type \"%s\"" s; scan ppf lexbuf
	| EQUAL -> fp ppf "="; scan ppf lexbuf
end


let mayr entry field f = let open Fields in  match entry.%{field.f} with
| None -> ()
| Some v -> f Format.std_formatter v

let ( *? ) = mayr


let decorated op en pr ppf e = Format.fprintf ppf "%s%a%s" op pr e en

let decoratedN name= decorated (Format.asprintf "\t %s: [" name) "]\n"

let plist sep = Format.pp_print_list ~pp_sep:(fun ppf () -> Format.fprintf ppf sep)

let plistn name pr = decoratedN name @@ plist ", "  pr

let setp name pr ppf s= s |> Fields.StrSet.elements |>  plistn name pr ppf

let pp_raw ppf entry = match Fields.(entry.%{raw}) with
  | None -> ()
  | Some dtb ->
    if Database.is_empty dtb then ()
    else
      let pp_binding ppf (key,x) = fp ppf "%s={%s}" key x in
      Format.fprintf ppf "raw={%a}" (plist ",@ " pp_binding) (Database.bindings dtb)

let () =
  let f=open_in "test.bib" in
  let bib = parse @@ Lexing.from_channel f in
  let open Fields in
  Database.iter (fun id entry ->
      p "Entry : %s \n " id;
      entry *? title @@ decoratedN "Title" string;
      entry *? authors
      @@ plistn "Authors"
        (fun ppf {firstname;lastname} -> fp ppf "%s %s" firstname lastname);
      entry *? year @@ decoratedN "Year" int;
      entry *? journal @@  decoratedN "Journal" string;
      entry *? volume @@  decoratedN "Volume" int;
      entry *? number @@  decoratedN "Number" int;
      entry *? pages @@
      (fun ppf -> function Loc k -> fp ppf "\t Pages: [%d] \n" k
              | Interv(k,l) -> fp ppf "\t Pages: [%d-%d] \n" k l
      );
      entry *? arxiv @@  decoratedN "Arxiv" string;
      entry *? doi @@  plistn "Doi" string;
      entry *? tags  @@  setp "Tags" string;
      entry *? abstract @@  decoratedN "Abstract" string;
      pp_raw Format.std_formatter entry
    ) bib
