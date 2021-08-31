// tag::state[]
type State = (int * int * int)
// end::state[]
// tag::levers[]
type Lever = State -> State

let bump n =
  match n with
  | 1 -> 2
  | 2 -> 3
  | 3 -> 1
  | _ -> failwith "Well, fuck"

let leftLever (a, b, c) = (a, bump b, bump c)
let rightLever (a, b, c) = (bump a, bump b, c)
// end::levers[]

let showState (a, b, c) = sprintf "%d%d%d" a b c

let showTransition label a b =
  sprintf "%s --> %s: %s" (showState a) (showState b) label

let diagram start goal =
  let rec loop acc vis curr =

    if curr = goal then
      acc
    elif List.contains curr vis then
      acc
    else
      let vis = curr :: vis
      let left = leftLever curr
      let right = rightLever curr

      let accL =
        acc @ [ showTransition "left" curr left ]

      let accR =
        acc @ [ showTransition "right" curr right ]

      loop accL vis left @ loop accR vis right

  [ "@startuml"
    "hide empty description"
    "!theme plain"
    sprintf "[*] --> %s" (showState start) ]
  @ loop [] [] start
    @ [ sprintf "%s --> [*]" (showState goal)
        "@enduml" ]
  |> List.except [| "" |]
  |> List.distinct
  |> String.concat "\n"

// ---- data ---
let start = (3, 3, 3)
let goal = (2, 2, 1)

// ---- print it! ---
printfn "%s" (diagram start goal)
