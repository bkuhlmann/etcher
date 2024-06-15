#//# --------------------------------------------------------------------------------------
#//# Created using Sequence Diagram for Mac
#//# https://www.macsequencediagram.com
#//# https://itunes.apple.com/gb/app/sequence-diagram/id1195426709?mt=12
#//# --------------------------------------------------------------------------------------
title "Etcher Architecture"

participant Load
participant Transform
participant Override
participant Validate
participant Model
participant Result

Load->Load: Iterate.

note over Load
  "Sequentially loads all configurations into a single set of attributes."
end note

Load->Transform: Transfer.
Transform->Transform: Iterate.

note over Transform
  "Sequentially transforms attributes."
end note

Transform->Override: Transfer.

note over Override
  "Merges specific changes."
end note

Override->Validate: Transfer.

note over Validate
  "Ensures attributes are valid."
end note

Validate->Model: Transfer.

note over Model
  "Models attributes as a single record."
end note

Model->Result: Respond.

note over Result
  "Answers monad with record or errors."
end note
