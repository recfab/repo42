open System

type Employer = string
type WorkItem = string
type Icon = string

type EndWork =
  | Until of DateTime
  | Present

type Technology = { Name: string; Icon: Icon }

type Employment =
  { Employer: Employer
    Started: DateTime
    Ended: EndWork
    Highlights: WorkItem list }
