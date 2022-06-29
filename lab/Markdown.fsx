#r "nuget: Markdig"
#r "nuget: YamlDotNet"

open System
open Markdig
open Markdig.Parsers
open System.IO

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
let journals = notesRoot </> "journals"

let js = getMarkdownFiles journals
