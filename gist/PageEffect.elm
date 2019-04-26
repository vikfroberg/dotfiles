module App.PageEffect exposing (..)


type PageEffect msg
    = OnKeyPress (Decoder msg)
    | OnKeyDown (Decoder msg)
    | OnKeyUp (Decoder msg)
    | OnClick (Decoder msg)
    | OnMouseMove (Decoder msg)
    | OnMouseDown (Decoder msg)
    | OnMouseUp (Decoder msg)
    | OnResize (Int -> Int -> msg)
    | OnVisibilityChange (Browser.Events.Visibility -> msg)
    | OnUrlChange (Url -> msg)
    | UrlPush Url
    | UrlReplace Url
    | DownloadString String String String
    | DownloadBytes String String Bytes
    | DownloadUrl String
    | SelectFile (List String) (File -> msg)
    | SelectFiles (List String) (File -> List File -> msg)
    | Blur String
    | Focus String
    | GetViewport (Browser.Dom.Viewport -> msg)
    | SetViewport Float Float
    | GetViewportOf String (Browser.Dom.Viewport -> msg)
    | SetViewportOf String Float Float
    | GetElement String (Browser.Dom.Element -> msg)


equal : PageEffect -> PageEffect -> Bool
equal x y =
    case ( x, y ) of
        ( OnKeyPress _, OnKeyPress _ ) ->
            True

        ( OnKeyDown _, OnKeyDown _ ) ->
            True

        ( OnKeyUp _, OnKeyUp _ ) ->
            True

        ( OnClick _, OnClick _ ) ->
            True

        ( OnMouseMove _, OnMouseMove _ ) ->
            True

        ( OnMouseDown _, OnMouseDown _ ) ->
            True

        ( OnMouseUp _, OnMouseUp _ ) ->
            True

        ( OnResize _, OnResize _ ) ->
            True

        ( OnVisibilityChange _, OnVisibilityChange _ ) ->
            True

        ( OnUrlChange _, OnUrlChange _ ) ->
            True

        ( UrlPush url, UrlPush url2 ) ->
            (==) url url2

        ( UrlReplace url, UrlReplace url2 ) ->
            (==) url url2

        ( DownloadString name mime str, DownloadString name2 mime2 str2 ) ->
            (==) (name, mime, str) (name2, mime2, str2)

        ( DownloadBytes name mime bytes, DownloadBytes name2 mime2 bytes2 ) ->
            (==) (name, mime, str) (name2, mimes2, str2)

            True
        ( DownloadUrl url, DownloadUrl url2 ) ->
            (==) url url2

        ( SelectFile mimes _, SelectFile mimes2 _ ) ->
            (==) mimes mimes2

        ( SelectFiles mimes _, SelectFiles mimes2 _ ) ->
            (==) mimes mimes2

        ( Blur id, Blur id2 ) ->
            (==) id id2

        ( Focus id, Focus id2 ) ->
            (==) id id2

        ( GetViewport _, GetViewport _ ) ->
            True

        ( SetViewport x y, SetViewport x2 y2 ) ->
            (==) (x,y) (x2,y2)

        ( GetViewportOf id _, GetViewportOf id2 _ ) ->
            (==) id id2

        ( SetViewportOf id x y, SetViewportOf id2 x2 y2 ) ->
            (==) (id, x,y) (id2, x2,y2)

        ( GetElement id _, GetElement id2 _ ) ->
            (==) id id2

        _ ->
            False
