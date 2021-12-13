# Myst Remake: Clock Tower Puzzle

There is a clock tower on the South side of the island. Inside is a puzzle with gears and levers.
The goal is to pull the levers in the right order to get the gears into the correct state.

I had thought solve this with a state machine, using F#.

* 3 gears, stacked on top of each other, with the teeth labeled 1, 2 or 3
+
[source,fsharp]
----
include::session.fsx[tags#state]
----

* 2 levers, each changing 2 of the 3 numbers
+
[source,fsharp]
----
include::session.fsx[tags#levers]
----

There is a `diagram` function, which generates a State Machine diagram

.State machine
[mermaid]
....

stateDiagram-v2
[*] --> 333
333 --> 311: left
311 --> 322: left
322 --> 333: left
322 --> 132: right
132 --> 113: left
113 --> 121: left
121 --> 132: left
121 --> 231: right
231 --> 212: left
212 --> 223: left
223 --> 231: left
223 --> 333: right
212 --> 322: right
231 --> 311: right
113 --> 223: right
132 --> 212: right
311 --> 121: right
333 --> 113: right
221 --> [*]
....

// image::diagram.svg[]

Unfortunately, it never resolves.
I must have the misunderstood the rules, or found the wrong starting clue.

