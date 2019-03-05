module Diff exposing (..)


type Change a
    = Move a
    | Append a
    | Drop a
    | Replace a
    | None


diff a b =
    None


x = [1,2,3,4]
y = [1,2,4,3]

changes = diff x y

