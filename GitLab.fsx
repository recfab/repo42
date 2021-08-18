type Script =
  | ScriptRef of string
  | ScriptBlock of string list

type ImageMeta =
  { Name: string
    Entrypoint: string list }

type Image =
  | Image of string
  | ImageMeta of ImageMeta

type VariablesBlock = Map<string, string>

type Job =
  { Image: Image
    Variables: VariablesBlock
    Script: Script }

type WhenClause =
  | Always
  | Manual

type IfClause = string

type WorkflowRule =
  { If: IfClause option
    When: WhenClause }

type Workflow = { Rules: WorkflowRule list }
