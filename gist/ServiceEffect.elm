module App.ServiceEffect exposing (..)

type ServiceEffect msg
    -- Separate these so that we can kill process for GET but not for POST
    = HttpPost
        { headers : List Header
        , url : String
        , body : Body
        , timeout : Maybe Float
        , tracker : Maybe String
        }
        Decoder a
    | HttpGet
        { headers : List Header
        , url : String
        , body : Body
        , timeout : Maybe Float
        , tracker : Maybe String
        }
        (Expect msg)
    | RandomGenerate (a -> msg) (Generator a)
    | TimeNow (Time -> msg)
    | OnTimeEvery Time (Time -> msg)
    | OnVisibilityChange (Browser.Events.Visibility -> msg)
    | Port


map : (msg -> msg2) -> ServiceEffect msg -> ServiceEffect msg2
map f x =
    case x of
    HttpPost data toMsg decoder ->
        HttpPost data (toMsg >> f) decoder

    HttpGet data toMsg decoder ->
        HttpGet data (toMsg >> f) decoder

    RandomGenerate toMsg gen ->
        RandomGenerate (toMsg >> f) gen

    TimeNow toMsg ->
        TimeNow (toMsg >> f)

    OnTimeEvery time toMsg ->
        OnTimeEvery time (toMsg >> f)


equal : ServiceEffect -> ServiceEffect -> Bool
equal x y =
    case ( x, y ) of
        ( HttpPost config _ , HttpPost config2 _ ) ->
            (==) config config2

        ( HttpGet config _ , HttpGet config2 _ ) ->
            (==) config config2

        ( RandomGenerate _ _, RandomGenerate _ _ ) ->
            True

        ( TimeNow _, TimeNow _ ) ->
            True

        ( OnTimeEvery time _, OnTimeEvery time2 _ ) ->
            (==) time time2

        _ ->
            False
