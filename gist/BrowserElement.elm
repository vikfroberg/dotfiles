module Main exposing (..)

import Html
import Browser

main : Program () () ()
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

init _ =
    ( (), Cmd.none )

update msg model =
    ( model, Cmd.none )

subscriptions model =
    Sub.none

view model =
    Html.text "view"

