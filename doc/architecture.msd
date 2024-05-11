#//# --------------------------------------------------------------------------------------
#//# Created using Sequence Diagram for Mac
#//# https://www.macsequencediagram.com
#//# https://itunes.apple.com/gb/app/sequence-diagram/id1195426709?mt=12
#//# --------------------------------------------------------------------------------------
title "Etcher Architecture"

participant Load
participant Override
participant Transform
participant Validate
participant Model
participant Result

Load->Load: Load.

note over Load
  "Sequentially reduces default configurations into a single merged configuration."
end note

Load->Override: Transfer.

Override->Transform: Override (optional).

note over Override
  "Merges specific overrides."
end note

Transform->Transform: Transform (optional).

note over Transform
  "Sequentially transforms individual values within merged configuration."
end note

Transform->Validate: Transfer.

Validate->Model: Validate

note over Validate
  "Ensures attributes are valid."
end note

Model->Result: Record

note over Model
  "Converts attributes into a structured record."
end note

note over Result
  "Answers monad with record or errors."
end note
