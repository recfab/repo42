#r "nuget: Markdig"
#r "nuget: YamlDotNet"

open System
open System.IO
open System.Linq
open System.Text
open Markdig
open Markdig.Extensions.Yaml
open Markdig.Syntax
open YamlDotNet.Serialization
open YamlDotNet.Serialization.NamingConventions

let newId () =
  Path.GetRandomFileName()
  |> Path.GetFileNameWithoutExtension

// 36^8 =  36 ^ 8 = 2.82110990746e+12
// 2,821,109,907,460

let listFiles dir = Directory.EnumerateFiles(dir, "*.md")

let extractFrontMatter (pipeline: MarkdownPipeline) file =
  let content = File.ReadAllText file
  let doc = Markdown.Parse(content, pipeline)

  let fm =
    doc
      .Descendants<YamlFrontMatterBlock>()
      .FirstOrDefault()
      .Lines.ToString()

  fm

// let files = listFiles "notes"


let pipeline =
  MarkdownPipelineBuilder()
    .UseYamlFrontMatter()
    .Build()

let deserializer =
  DeserializerBuilder()
    .WithNamingConvention(CamelCaseNamingConvention.Instance)
    .Build()
