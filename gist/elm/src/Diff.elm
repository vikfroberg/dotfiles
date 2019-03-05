module Diff exposing (..)

import Set
import Dict
import Array

tupleFold f ( a, b ) =
    f a b


arrayFind x xs =
    xs
        |> Array.toIndexedList
        |> List.filterMap (\( index, y ) ->
            if x == y then
                Just index
            else
                Nothing
        )
        |> List.head

listFind xs x =
    xs
        |> List.filterMap (\y ->
            if x == y then
                Just x
            else
                Nothing
        )
        |> List.head


type Change comparable a
    = Replaced a Int
    | Removed Int
    | Added a
    | Moved Int Int


toWeight change =
    case change of
        Replaced _ _ ->
            0

        Removed _ ->
            1

        Added _ ->
            2

        Moved _ _ ->
            3


fold : (Change comparable a -> b -> b) -> b -> List (Change comparable a) -> b
fold f b xs =
    xs
        |> List.sortBy toWeight
        |> List.foldl f b


diff leftList rightList =
    let
        leftArray =
            leftList
                |> List.map Tuple.first
                |> Array.fromList

        rightArray =
            rightList
                |> List.map Tuple.first
                |> Array.fromList

        leftDict =
            Dict.fromList leftList

        rightDict =
            Dict.fromList rightList

        removed =
            Dict.diff leftDict rightDict
                |> Dict.toList
                |> List.filterMap (\( key, val ) ->
                    leftArray
                        |> arrayFind key
                        |> Maybe.map Removed
                )

        added =
            Dict.diff rightDict leftDict
                |> Dict.toList
                |> List.map (Tuple.second >> Added)

        replaced =
            rightDict
                |> Dict.toList
                |> List.filterMap (\( key, rightValue ) ->
                    leftDict
                        |> Dict.get key
                        |> Maybe.andThen (\leftValue ->
                            if leftValue == rightValue then
                                Nothing
                            else
                                leftArray
                                    |> arrayFind key
                                    |> Maybe.map (Replaced rightValue)
                        )
                )

        moved =
            List.append
                (Dict.intersect leftDict rightDict |> Dict.toList)
                (Dict.diff rightDict leftDict |> Dict.toList)
                |> Array.fromList >> Array.toIndexedList
                |> List.filterMap (\( index, ( key, val ) ) ->
                    rightArray
                        |> arrayFind key
                        |> Maybe.andThen (\rightIndex ->
                            if index == rightIndex then
                                Nothing
                            else
                                if index > rightIndex then
                                    Just (rightIndex, index)
                                else
                                    Just (index, rightIndex)
                        )
                )
                |> Set.fromList
                |> Set.toList
                |> List.map (tupleFold Moved)
    in
    replaced ++ removed ++ added ++ moved


left =
        [ ( "1", "Viktor" )
        , ( "2", "Sanna" )
        , ( "3", "Simon" )
        ]


right =
        [ ( "1", "Viktor" )
        , ( "2", "Sanna" )
        , ( "4", "Alex" )
        , ( "3", "Robin" )
        ]


changes =
    diff left right
