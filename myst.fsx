// ---- types and logic function ----
type State = (int * int * int)
type Lever = State -> State

let bump n =
  match n with
  | 1 -> 2
  | 2 -> 3
  | 3 -> 1
  | _ -> failwith "Well, fuck"

let leftLever (a, b, c) = (a, bump b, bump c)
let rightLever (a, b, c) = (bump a, bump b, c)

// ---- display functions ----
let showRef (a, b, c) = sprintf "st%d%d%d" a b c

let showDef (a, b, c) =
  sprintf "state \"%d\\n%d\\n%d\" as %s" a b c (showRef (a, b, c))

let showLever (lever: Lever) label (st: State) =
  let a = st |> showRef
  let b = st |> lever |> showRef
  sprintf "%s --> %s : %s" a b label

let showLeftLever = showLever leftLever "left"
let showRightLever = showLever rightLever "right"

// ---- data ---
let start = (3, 3, 3)
let goal = (2, 2, 1)

let allStates =
  seq {
    for a in [ 1; 2; 3 ] do
      for b in [ 1; 2; 3 ] do
        for c in [ 1; 2; 3 ] do
          yield (a, b, c)
  }
  |> Seq.toList

// ---- print it! ---
let diagram =
  [ "stateDiagram-v2" ]
  @ [ sprintf "[*] --> %s" (showRef start) ]
    @ (List.map showDef allStates)
      @ (List.map showLeftLever allStates)
        @ (List.map showRightLever allStates)
          @ [ sprintf "%s --> [*]" (showRef goal) ]

let diagram' = String.concat "\n" diagram

printf "%s" diagram'
