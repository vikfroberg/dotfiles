module Diff exposing (..)

import Set
import Dict
import Array
import Html
import List.Extra as List

listMax xs ys =
    if List.length xs > List.length ys then
        xs
    else
        ys

listLcs xs ys j k =
    let
        xs_ = List.tail xs |> Maybe.withDefault []
        ys_ = List.tail ys |> Maybe.withDefault []
    in
        if List.length xs == 0 || List.length ys == 0 then
            []
        else
            Maybe.map2
                (\x y ->
                    if x == y then
                        [ ( j, k ) ] ++ listLcs xs_ ys_ (j + 1) (k + 1)
                    else
                        listMax
                            (listLcs xs ys_ j (k + 1))
                            (listLcs xs_ ys (j + 1) k)
                )
                (List.head xs)
                (List.head ys)
                |> Maybe.withDefault []

diff xs ys =
    let
        _ = Debug.log "diff" ( xs, ys )

        lcs =
            listLcs xs ys 0 0

        free =
            lcs
                |> List.map Tuple.second
                |> (\zs ->
                    Set.diff
                        (List.range 0 (List.length ys - 1) |> Set.fromList)
                        (zs |> Set.fromList)
                        |> Set.toList
                )

        inserts =
            free
                |> List.filterMap (\to ->
                    ys
                        |> Array.fromList
                        |> Array.get to
                        |> Maybe.map (\y -> ( y, to ))
                )

        updates =
            lcs
                |> List.filterMap (\( from, to ) ->
                    ys
                        |> Array.fromList
                        |> Array.get to
                        |> Maybe.map (\y -> ( y, from ))
                )

        removes =
            lcs
                |> List.map Tuple.first
                |> Set.fromList
                |> (\zs ->
                    Set.diff
                        (List.range 0 (List.length xs - 1) |> Set.fromList)
                        zs
                )
                |> Set.toList
                -- |> List.filter (\i -> ys |> Array.fromList |> Array.get i |> Maybe.map (always False) |> Maybe.withDefault True)

    in
    Debug.log
        "diff"
        ( updates
        , removes
        , inserts
        )

test =
    [ diff [ "a" ] [ "a", "b" ] -- add to end
    , diff [ "a" ] [ "b", "a" ] -- add to beginning
    , diff [ "a", "b" ] [ "a" ] -- remove end
    , diff [ "a", "b" ] [ "b" ] -- remove beginning
    , diff [ "a", "b" ] [ "b", "a" ] -- swap // works but should reuse A instead of insert/remove
    , diff [ "a", "b" ] [ "a", "c", "b" ] -- add in middle
    , diff [ "a", "b" ] [ "a", "c", "b", "d" ] -- add in and end
    ]

main =
    let
        _ = test
    in
    Html.text "hej"
