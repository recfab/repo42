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
  DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
  |> BitConverter.GetBytes
  |> Convert.ToHexString

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

let files = listFiles "kb"


let pipeline =
  MarkdownPipelineBuilder()
    .UseYamlFrontMatter()
    .Build()

let deserializer =
  DeserializerBuilder()
    .WithNamingConvention(CamelCaseNamingConvention.Instance)
    .Build()

let metadata: dynamic = deserializer.Deserialize(fm)
