module ActorTest exposing (..)

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

-- Logger


type ActorModel
    = Logger LoggerModel

-- How to solve circular imports for msg + init?

type ActorMsg
    = MsgLogger LoggerMsg

type Msg
    = None
    | Spawn { name : String, actorModel : Actor, actorMsgs : List Msg }
    | Kill { pid : String }
    | Send { pid : String, msgs : ActorMsg }

type alias Model =
    { processes : Dict Int ActorModel
    { counter : Int
    }

init _ =
    { processes = Dict.empty
    , counter = 0
    }

update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        Send { pid, msg } ->
            case Dict.get pid model.processes of
                Just process ->
                    case ( process, msg ) of
                        ( Logger subModel, MsgLogger subMsg ) ->
                            loggerUpdate subMsg subModel

                Nothing ->
                    let
                        _ =
                            Debug.log "No actor process with pid" pid
                    in
                    ( model, Cmd.none )

        Spawn { name, actorModel, actorMsgs } ->
            case actorModel of
                Logger subModel ->

            ( model, Cmd.none )

        Kill { pid } ->
            ( model, Cmd.none )

