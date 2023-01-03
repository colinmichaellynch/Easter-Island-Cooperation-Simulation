turtles-own[energy cooperative prob-death death-count lifespan timestepsGreen timestepsBlack cellSequence patchHop]
patches-own[plant-energy]
extensions[csv]
globals[initial-energy counter second-counter first-x first-y cooperative-count is-it-raining is-it-raining-list rain-counter rain-list patch-number col-number cooperator-list noncooperator-list cooperator-lifespan-list noncooperator-lifespan-list cooperator-greentile-list cooperator-blacktile-list noncooperator-greentile-list noncooperator-blacktile-list patchHop-cooperators patchHop-noncooperators]

to setup
  clear-all
  reset-ticks
  set initial-energy 0
  set counter 0
  set is-it-raining 0
  set rain-list []
  set is-it-raining-list []
  set cooperator-list []
  set noncooperator-list []
  set cooperator-lifespan-list []
  set noncooperator-lifespan-list []
  set cooperator-greentile-list []
  set cooperator-blacktile-list []
  set noncooperator-greentile-list []
  set noncooperator-blacktile-list []
  set patchHop-cooperators []
  set patchHop-noncooperators []
  set patch-number ceiling (minimum-plant-number / (patch-width ^ 2))
  set col-number ceiling ( sqrt ( patch-number + 1 ) * gap-width + sqrt ( patch-number ) * patch-width )
  resize-world 0 col-number 0 col-number
  setup-patches
  setup-turtles
  set-rain
end

to go
  if ticks >= 1000
  [stop]
  move-turtles
  count-tiletype
  patch-hop-count
  eat-grass
  reproduce
  check-death
  rain
  regrow-grass
  set initial-energy 0
  count-turtles
  if count turtles = 0
  [stop]
  tick
end

to setup-turtles
  create-turtles initial-population [setxy random-xcor random-ycor]
  ask turtles[
    set shape "person"
    set energy random 100
    set cooperative random 2
    set death-count 0
    set lifespan 0
    set timestepsGreen 0
    set timestepsBlack 0
    set patchHop 0
    set cellSequence []
    ifelse cooperative = 1
    [set color blue]
    [set color red]
  ]
end

to setup-patches
  ask patches [
    set plant-energy 0
    set-seed
    set-color
  ]
end

to set-seed
  let i gap-width
  let j gap-width
  while [ j < col-number ] [
    while [ i < col-number] [
      if (pxcor >= i) and (pxcor <= i + patch-width - 1) and (pycor >= j) and (pycor <= j + patch-width - 1)
         [set plant-energy 1 + random 9
         set-color]
      set i i + gap-width + patch-width
    ]
    set i gap-width
    set j j + gap-width + patch-width
  ]
end

to set-color
    ifelse plant-energy > 2
    [set pcolor green]
    [set pcolor brown]
    if plant-energy = 0
    [set pcolor black]
end

to move-turtles
  ask turtles [
    set first-x pxcor
    set first-y pycor
    set counter 0
    set second-counter 0
    set lifespan lifespan + 1

    ifelse cooperative = 0
    [while [counter < 8]
      [move-to max-one-of patches in-radius 2 [plant-energy]
       ifelse count turtles-here = 1
        [ifelse (energy-transfer-non-cooperator * plant-energy) < 2
        [setxy first-x first-y
        set counter counter + 1
        set second-counter second-counter + 1]
        [set energy energy - 2
            set counter 8]]
        [setxy first-x first-y
        set counter counter + 1
        set second-counter second-counter + 1]
      ]

    if second-counter = 8
      [setxy first-x first-y
      right random 360
      forward 1
      set energy energy - 2]
    ]
    [while [counter < 8]
      [move-to max-one-of patches in-radius 2 [plant-energy]
       ifelse count turtles-here = 1
        [ifelse (energy-transfer-cooperator * plant-energy) < 2
        [setxy first-x first-y
        set counter counter + 1
        set second-counter second-counter + 1]
        [set energy energy - 2
            set counter 8]]
        [setxy first-x first-y
        set counter counter + 1
        set second-counter second-counter + 1]
      ]

    if second-counter = 8
      [setxy first-x first-y
      right random 360
      forward 1
      set energy energy - 2]
  ]
  ]
end

to count-tiletype
  ask turtles[
    if (pcolor = 55) or (pcolor = 35); or (pcolor = 97)
    [set timestepsGreen timestepsGreen + 1
    set cellSequence lput 1 cellSequence]
    if pcolor = 0
    [set timestepsBlack timestepsBlack + 1
    set cellSequence lput 0 cellSequence]
  ]
end

to patch-hop-count
  ask turtles[
     if ticks > 1
        [if item ticks cellSequence != item (ticks - 1) cellSequence
          [set patchHop patchHop + 1]
    ]
  ]
end

to eat-grass
  ask turtles[
    ifelse cooperative = 0
    [set energy energy + (energy-transfer-non-cooperator * plant-energy) - .01
    set plant-energy plant-energy - (energy-transfer-non-cooperator * plant-energy)
    ]
    [set energy energy + (energy-transfer-cooperator * plant-energy) - .01
    set plant-energy plant-energy - (energy-transfer-cooperator * plant-energy)
    ]

    ifelse show-energy?
    [set label energy]
    [set label ""]
  ]
end

to reproduce
  ask turtles [
   if energy >  100 [
     set initial-energy initial-energy + random 100
     set energy energy - initial-energy
      hatch 1 [
        set energy initial-energy
        set cooperative cooperative
        set death-count 0
          ifelse cooperative = 1
          [set color blue]
          [set color red]]
      set initial-energy 0
    ]
  ]

end

to check-death
  ask turtles [
    if energy <= 0
    [
      ifelse cooperative = 1
      [
        set cooperator-greentile-list lput timestepsGreen cooperator-greentile-list
        set cooperator-blacktile-list lput timestepsBlack cooperator-blacktile-list
        set cooperator-lifespan-list lput lifespan cooperator-lifespan-list
        set patchHop-cooperators lput patchHop patchHop-cooperators
      ]
      [
        set noncooperator-greentile-list lput timestepsGreen noncooperator-greentile-list
        set noncooperator-blacktile-list lput timestepsBlack noncooperator-blacktile-list
        set noncooperator-lifespan-list lput lifespan noncooperator-lifespan-list
        set patchHop-noncooperators lput patchHop patchHop-noncooperators
      ]
      die
  ]
  ]
end

to rain
  set is-it-raining item ticks rain-list
end

to set-rain
  let k (10 * P ) + 1
  let m log average-rain 3 + 1
  let n log average-drought 3 + 1
  let index k + 11 * ( m - 1) + 55 * ( n - 1 )
  let data csv:from-file "rain_matrix.csv"
  let dataone remove-item 0 data
  set rain-list item ( index - 1 ) dataone
  set rain-list remove-item 0 rain-list
end

to regrow-grass ;check if raining or not, only grow if is-it-raining = 1
  ask patches [
  ifelse pcolor = green or pcolor = brown or pcolor = 97
  [
  ifelse is-it-raining = 1
  [
       set plant-energy plant-energy + ((logistic-growth-rate * plant-energy * (10 - plant-energy)) / 10)
       ;set pcolor 97
       ;for visualization, undo the ; above

       if plant-energy > 10
           [set plant-energy 10]
  ]
  [ifelse plant-energy > 2
      [set pcolor green]
      [set pcolor brown]
    ]
    if plant-energy = 0
    [set plant-energy .01]
  ]
  [set plant-energy 0]
  ]
end

to count-turtles
  set cooperator-list lput (count turtles with [cooperative = 1]) cooperator-list
  set noncooperator-list lput (count turtles with [cooperative = 0]) noncooperator-list
end
@#$#@#$#@
GRAPHICS-WINDOW
569
14
1188
634
-1
-1
13.0
1
10
1
1
1
0
1
1
1
0
46
0
46
1
1
1
ticks
30.0

BUTTON
324
18
387
51
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
395
18
458
51
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
324
55
396
100
NIL
count turtles
17
1
11

SWITCH
324
104
458
137
show-energy?
show-energy?
1
1
-1000

PLOT
21
599
307
862
Energy of Turtles (Purple) vs Patches (Green) 
Ticks
Energy Units
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -8630108 true "" "plot sum [energy] of turtles"
"pen-1" 1.0 0 -14439633 true "" "plot sum [plant-energy] of patches"

PLOT
20
329
308
593
Cooperators (Blue) vs Non-Cooperators (Red)
Ticks
Count
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Cooperators" 1.0 0 -13345367 true "" "plot count turtles with [cooperative = 1]"
"Non-Cooperators" 1.0 0 -8053223 true "" "plot count turtles with [cooperative = 0]"

PLOT
21
172
308
322
Energy of Turtle 1
Ticks
Energy Units
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "ask turtle 1 [plot energy]"

PLOT
21
16
308
166
Energy of Patch (gap-width, gap-width)
Ticks
Energy Units
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "ask patch gap-width gap-width [plot plant-energy]"

SLIDER
322
313
445
346
initial-population
initial-population
0
100
40.0
1
1
NIL
HORIZONTAL

SLIDER
323
271
469
304
logistic-growth-rate
logistic-growth-rate
0
1
0.4
.01
1
NIL
HORIZONTAL

SLIDER
322
357
531
390
energy-transfer-non-cooperator
energy-transfer-non-cooperator
0
1
1.0
.01
1
NIL
HORIZONTAL

PLOT
319
552
553
702
Duration of Rain Distribution
Length of Rainfall Event (Ticks)
Frequency
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram rain-list"

PLOT
319
712
552
862
Is it Raining? 
Ticks
1 = Raining
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -8275240 true "" "plot is-it-raining"

SLIDER
324
146
416
179
patch-width
patch-width
1
10
6.0
1
1
NIL
HORIZONTAL

SLIDER
324
186
416
219
gap-width
gap-width
0
10
6.0
1
1
NIL
HORIZONTAL

SLIDER
323
227
473
260
minimum-plant-number
minimum-plant-number
1
500
500.0
1
1
NIL
HORIZONTAL

SLIDER
408
60
500
93
P
P
0
1
1.0
.1
1
NIL
HORIZONTAL

CHOOSER
322
444
460
489
average-rain
average-rain
1 3 9 27 81
4

CHOOSER
321
497
459
542
average-drought
average-drought
1 3 9 27 81
4

SLIDER
322
400
526
433
energy-transfer-cooperator
energy-transfer-cooperator
0
1
0.3
.1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="final_sims" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>mean cooperator-list</metric>
    <metric>mean noncooperator-list</metric>
    <metric>mean cooperator-lifespan-list</metric>
    <metric>mean noncooperator-lifespan-list</metric>
    <metric>mean cooperator-greentile-list</metric>
    <metric>mean cooperator-blacktile-list</metric>
    <metric>mean noncooperator-greentile-list</metric>
    <metric>mean noncooperator-blacktile-list</metric>
    <metric>mean patchHop-cooperators</metric>
    <metric>mean patchHop-noncooperators</metric>
    <enumeratedValueSet variable="show-energy?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-drought">
      <value value="1"/>
      <value value="3"/>
      <value value="9"/>
      <value value="27"/>
      <value value="81"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="logistic-growth-rate">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="gap-width">
      <value value="0"/>
      <value value="2"/>
      <value value="4"/>
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="minimum-plant-number">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-population">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-rain">
      <value value="1"/>
      <value value="3"/>
      <value value="9"/>
      <value value="27"/>
      <value value="81"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energy-transfer-cooperator">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energy-transfer-non-cooperator">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P">
      <value value="0"/>
      <value value="0.2"/>
      <value value="0.4"/>
      <value value="0.6"/>
      <value value="0.8"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-width">
      <value value="2"/>
      <value value="4"/>
      <value value="6"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="final_sims" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>mean cooperator-list</metric>
    <metric>mean noncooperator-list</metric>
    <metric>mean cooperator-lifespan-list</metric>
    <metric>mean noncooperator-lifespan-list</metric>
    <metric>mean cooperator-greentile-list</metric>
    <metric>mean cooperator-blacktile-list</metric>
    <metric>mean noncooperator-greentile-list</metric>
    <metric>mean noncooperator-blacktile-list</metric>
    <metric>mean patchHop-cooperators</metric>
    <metric>mean patchHop-noncooperators</metric>
    <enumeratedValueSet variable="show-energy?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-drought">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="logistic-growth-rate">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="gap-width">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="minimum-plant-number">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-population">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-rain">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energy-transfer-cooperator">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energy-transfer-non-cooperator">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-width">
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
