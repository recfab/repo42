#r "nuget: Markdig"
#r "nuget: YamlDotNet"
#r "nuget: FsCheck"

open System
open System.IO

open System.Text.RegularExpressions

open FsCheck
open Markdig
open Markdig.Parsers

type MarkdownDoc = MarkdownDoc of string
let (</>) a b = Path.Join([| a; b |])

let getMarkdownFiles dir =
  Directory.GetFiles(dir, "*.md")
  |> List.ofArray
  |> List.map Path.GetFileName

let pipeline =
  MarkdownPipelineBuilder()
    .UseYamlFrontMatter()
    .Build()

let parse text =
  MarkdownParser.Parse(text, pipeline, null)

let notesRoot = "./notes"
let journalRoot = notesRoot </> "journals"

let journals = getMarkdownFiles journalRoot

let (|YMD|_|) input =
  let pattern =
    "(\d{1,4})[_.](\d{1,2})[_.](\d{1,2})\.md"

  let m = Regex.Match(input, pattern)

  if m.Success then
    [ for g in m.Groups -> g.Value ]
    |> List.tail
    |> fun [ y; m; d ] -> (y, m, d)
    |> Some
  else
    None

let normalizeFileName p =
  match p with
  | YMD (y, m, d) -> sprintf "%s_%s_%s.md" y m d |> Some
  | _ -> None

type NormalizationSpec =
  static member ``already normalized``(dt: DateTime) =
    let input =
      sprintf "%d_%d_%d.md" dt.Year dt.Month dt.Day

    normalizeFileName input = Some input

  static member ``dendron formatted``(dt: DateTime) =
    let input =
      sprintf "daily.journal.%d.%d.%d.md" dt.Year dt.Month dt.Day

    let expected =
      sprintf "%d_%d_%d.md" dt.Year dt.Month dt.Day

    normalizeFileName input = Some expected

Check.QuickAll<NormalizationSpec>()


let normalized =
  journals
  |> List.map (fun x -> (x, normalizeFileName x))
