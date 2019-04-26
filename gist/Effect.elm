module App.Effect exposing (..)

import App.PageEffect as PageEffect exposing (PageEffect)
import App.ServiceEffect as ServiceEffect exposing (ServiceEffect)
import App.UIComponentEffect as UIComponentEffect exposing (UIComponentEffect)


type Effect msg
    = Combine (Dict String (Effect msg))
    | ServiceEffect (ServiceEffect msg)
    | PageEffect (PageEffect msg)
    | UIComponentEffect (UIComponentEffect msg)


map : (msg -> msg2) -> Effect msg -> Effect msg2
map f x =
    case x of
        Combine dict ->
            Combine (Dict.map map x)

        ServiceEffect a ->
            ServiceEffect.map f a

        PageEffect a ->
            PageEffect.map f a

        UIComponentEffect a ->
            UIComponentEffect.map f a


empty : Effect msg
empty =
    Combine Dict.empty


serviceEffect : ServiceEffect msg -> Effect msg
serviceEffect x =
    ServiceEffect x


uiComponentEffect : UIComponentEffect msg -> Effect msg
uiComponentEffect x =
    UIComponentEffect x


pageEffect : PageEffect msg -> Effect msg
pageEffect x =
    PageEffect x


insert : String -> Effect msg -> Effect msg
insert name y x =
    case x of
        Combine dict ->
            Combine (Dict.insert name y dict)

        _ ->
            x


remove : String -> Effect msg
remove name x =
    case x of
        Combine dict ->
            Dict.remove name dict

        _ ->
            x


type Diff a
    = Change (Dict String Diff)
    | Replace a
    | Remove
    | Add a
    | Keep


diff : Effect msg -> Effect msg -> Change
diff x y =
    case (x, y) of
        ( Combine dictX, Combine dictY ) ->
            let
                removes =
                    Dict.diff dictX dictY
                        |> Dict.map (always Remove)

                diffY =
                    Dict.map
                        (\name y_ ->
                            dictX
                                |> Dict.get name
                                |> Maybe.map (diff y_)
                                |> Maybe.withDefault Add y_
                        )
                        dictY
            in
            Dict.union diffY removes

        ( ServiceEffect x_, ServiceEffect y_ ) ->
            if ServiceEffect.equal x_ y_ then
                Keep
            else
                Replace (ServiceEffect y_)

        ( UIComponentEffect x_, UIComponentEffect y_ ) ->
            if UIComponentEffect.equal x_ y_ then
                Keep
            else
                Replace (UIComponentEffect y_)

        ( PageEffect x_, PageEffect y_ ) ->
            if PageEffect.equal x_ y_ then
                Keep
            else
                Replace (PageEffect y_)

        _ ->
            Replace y
