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

type Note =
  | Journal of (DateTime * MarkdownDoc)
  | Page of MarkdownDoc

let notesRoot = "../commonplace-book"
let importPath = notesRoot </> "vault/notes"
let journalsPath = notesRoot </> "journals"
let pagesPath = notesRoot </> "pages"

let notes = getMarkdownFiles importPath

let (|YMD|_|) input =
  let pattern =
    "(\d{1,4})[_.](\d{1,2})[_.](\d{1,2})\.md"

  let m = Regex.Match(input, pattern)

  if m.Success then
    [ for g in m.Groups -> g.Value ]
    |> fun (_ :: y :: m :: d :: []) -> (y, m, d)
    |> Some
  else
    None

let normalizeFileName p =
  match p with
  | YMD (y, m, d) ->
    sprintf "%s_%s_%s.md" y m d
    |> fun x -> journalsPath </> x
  | _ -> pagesPath </> p

type NormalizationSpec =
  static member ``already normalized``(dt: DateTime) =
    let input =
      sprintf "%d_%d_%d.md" dt.Year dt.Month dt.Day

    normalizeFileName input = (journalsPath </> input)

  static member ``dendron formatted``(dt: DateTime) =
    let input =
      sprintf "daily.journal.%d.%d.%d.md" dt.Year dt.Month dt.Day

    let expected =
      sprintf "%d_%d_%d.md" dt.Year dt.Month dt.Day

    normalizeFileName input = (journalsPath </> expected)

Check.QuickAll<NormalizationSpec>()

let renames =
  notes
  |> List.map (fun x -> (x, normalizeFileName x))
