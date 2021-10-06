// Learn more about F# at http://docs.microsoft.com/dotnet/fsharp

open Argu
open System

type Args =
  | Ls
  | NewNote
  interface IArgParserTemplate with
    member this.Usage =
      match this with
      | Ls -> "list notes"
      | NewNote -> "create a new note and opens it in $EDITOR"

// Define a function to construct a message to print
let from whom = sprintf "from %s" whom

[<EntryPoint>]
let main argv =
  let parser =
    ArgumentParser.Create<Args>(programName = "dat")

  let usage = parser.PrintUsage()
  printf "%s" usage
  0 // return an integer exit code
