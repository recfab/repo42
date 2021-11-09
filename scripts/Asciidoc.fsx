// The spec and corresponding TCK are not ready yet
// This file is partially based on the MR here:
// https://gitlab.eclipse.org/eclipse/asciidoc-lang/asciidoc-lang/-/merge_requests/6

type Node =
  | Preamble
  | Paragraph
  | Section
  | Verse
  | STEM
  | Sidebar
  | Quote
  | Open
  | Example
  | Listing
  | Literal
  | Admonition
  | Image
  | Video
  | Audio
  | Pass
  | AttributeReference
  | AttributeDefinition
  | Strong
  | Emphasis
  | Monospace
  | Subscript
  | Superscript
  | SingleQuotation
  | DoubleQuotation
  | Str
  | Anchor
  | OrderedList
  | UnorderedList
  | DescriptionList
  | InlineImage
  | InlineBreak
  | InlineButton
  | InlineMenu
  | InlineMacro
  | Table
