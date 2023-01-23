A simple bibtex parser using open records to encode strongly typed bibtex item.
To use this library, first parse a bibtex file using 

```Ocaml

let dtb = Bibtex.parse @@ Lexing.from_string
"
@article{ Nothingness,
title={On empty articles},
author={Nobody, U. and Nonymous, A.},
year={1995},
pages={0-0}
}
"
```
Bitex items are stored inside a string map using their identifiants
(e.g. "Nothingness" ) as key. 
```Ocaml
let item = Bibtex.Database.find "Nothingness" dtb
```

Item fields can be accessed using the open record syntax (see [orec](https://github.com/Octachron/orec)). For convenience, the module Bibtex_fields(=Bibtex.Fields) define a `'a named_field` type which combines an access field with a name and a conversion function to string. The list of predefined fields can be found in the `Bibtex_fields` module.

```Ocaml
let () =
    let open Bibtex.Fields in
    assert ( item.%{year.f} = Some 1995 );
    assert( item.%{page.f} = Some ( Interv(0,0) ) );
    assert( item.%{title.f} = Some "On empty articles" )

```

If needed, more fields can be added to the parser by using a custom [~with_keys] arguments.

First-class fields allow to write generic function like
```Ocaml
let mayp field fmt =
  let open Bibtex.Fields in
  match item.%{field} with
  | None -> ()
  | Some x -> Printf.printf fmt x  

let () =
    let open Bibtex.Fields in
    mayp (str kind) "@%s";
    mayp uid.f "{%s,\n";
    mayp title.f "title={%s},\n";
    mayp (str authors) "author={%s},\n";
    mayp year.f "year={%d},\n";
    mayp (str pages) "pages={%s},\n";
    print_string "}\n"

```



#Example
```Ocaml

let dtb = Bibtex.parse @@ Lexing.from_string
"
@article{ Nothingness,
title={On empty articles},
author={Nobody, U. and Nonymous, A.},
year={1995},
pages={0-0}
}
"

let item = Bibtex.Database.find "Nothingness" dtb
let mayp field fmt =
  let open Bibtex.Fields in
  match item.%{field} with
  | None -> ()
  | Some x -> Printf.printf fmt x  

let () =
    let open Bibtex.Fields in
    mayp (str kind) "@%s";
    mayp uid.f "{%s,\n";
    mayp title.f "title={%s},\n";
    mayp (str authors) "author={%s},\n";
    mayp year.f "year={%d},\n";
    mayp (str pages) "pages={%s},\n";
    print_string "}\n"

```
