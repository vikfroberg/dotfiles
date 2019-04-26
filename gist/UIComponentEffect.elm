module App.UIComponentEffect exposing (..)

type UIComponentEffect msg
    = OnAnimationFrame (Posix -> msg)
    | OnAnimationFrameDelta (Float -> msg)
    | OnVisibilityChange (Browser.Events.Visibility -> msg)
    | OnTimeEvery Time (Time -> msg)
    | GetElement String (Element -> msg)

equal : UIComponentEffect -> UIComponentEffect -> Bool
equal x y =
    case (x, y) of
        ( OnAnimationFrame _, OnAnimationFrame _ ) ->
            True

        ( OnAnimationFrameDelta _, OnAnimationFrameDelta _ ) ->
            True

        _ ->
            False
