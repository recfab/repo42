= Pluralsight: Packaging Apps with Helm

#pluralsight

* many resources
* manage dependencies and versions
 ** i.e.
it's a package manager
* `kubectl` is error proone, especially when you need to roll back
* helm charts
 ** stores release manifests in secrets
* upgrading: helm checks old chart, new chart and live state to create a patch
 ** \=> allows changes outside of helm
* some commands
 ** `+helm repo add stable ...+`
 ** `helm install`
 ** `helm uninstall`
 ** `helm env`
* `Chart.yml`
 ** `type` property
  *** usually "application"
  *** can also be "library" of reusable helper functions
 ** `appVersion` - version of the packaged app
 ** `version` - version o the chart itself

[,shell]
----
$ helm uninstall --keep-history
$ helm rollback RELEASE REVISION
----

* term: Umbrella Chart = chart with sub-charts
 ** e.g.
+
[,text]
----
Guestbook
┣╸ frontend
┣╸ backend
┗╸ database
----

 ** `global` property - define values for parent chart and all child charts
* testing
 ** `helm template` to render templates
 ** `helm install --dryrun --debug`
 ** can check schema of values file with `values.schema.json`
* helm charts can be customized with Go templates
 ** useful top level props to use in templates
  *** `.Values`
  *** `.Capabilities`
  *** `.Chart`
  *** `.Release`
  *** `.Files`
  *** `.Template`
 ** can use function syntax or pipe syntax
 ** template functions
  *** most from the Sprig project
  *** some from helm
 ** controlling space and indents
  *** dashes in directives remove whitespace
  *** `indent` function
 ** scope sections of templates using `with` keyword
 ** can define helpers and include them in other templates
 ** NOTES.txt
 ** when using `define`, the templates are global to chart and all sub-charts
  *** common to prefix with chart name
 ** lift values from child to parent
  *** \=> easier to use because config in one place
* common patterns
 ** name fo object derived from release name and chart name
 ** extract to values.yaml to make reusable
* packaging your chart
 ** basically a .tgx archive
 ** create with `helm package`
 ** Chart Museum - custom repo app for private charts
 ** manage dependencies
  *** each item has fields:
   **** `name`
   **** `version`
   **** `repository`
  *** dependencies
* helm 3 is backcompat with Helm 2 charts
 ** although deps were handled differently in v2
