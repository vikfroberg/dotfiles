-- type alias Router =
--     ( Layer, List Layer, TwoWayAnimation )


-- type LayerTransition
--     = Transition Layer Layer TwoWayAnimation
--     | NoTransition Layer


-- Doesn't work
-- type alias Router =
--     ( List Layer, LayerTransition )


-- listeners:
    -- when href changes how do we react and animate
    -- clicking link
    -- clicking back

-- force the order, so that you can only go to lower level?

-- how does it work when you land on area and then click
-- back button in ui and then click back button in browser?
-- do we care?

-- En öppen åt gången?
-- Close card panel on back?
-- varför visa card panel när stäng?
-- se till så card representerar vad som visas i mappen
-- scrolla mappen när kort öppnas



-- type RouteHeirarchy
--     = PracticeRoute
--     | AlphaRoute
--     | AreaOfConcernRoute



-- routes = [ PracticeRoute, AlphaRoute, AreaOfConcernRoute ]


-- type Tree branch leaf
--     = Branch ( branch, Tree )
--     | Leaf leaf


-- treePop : ( leaf -> ( branch, leaf ) ) -> Tree branch leaf-> Tree branch leaf
-- treePop tree =


-- treePush : ( leaf -> ( branch, leaf ) ) -> Tree branch leaf-> Tree branch leaf
-- treePush f tree =
--     case tree of
--         Branch ( branch, nextTree ) ->

--         Leaf leaf ->


-- treeLeaf : Tree branch leaf -> leaf
-- treeLeaf tree =
--     case tree of
--         Branch ( _, nextTree ) ->
--             treeLeaf nextTree

--         Leaf transitionLayer ->
--             transitionLayer


-- routerActiveLayer : Router -> Layer
-- routerActiveLayer ( firstLayer, restLayers, animation ) =
--     restLayers
--         |> List.reverse >> List.head
--         |> Maybe.withDefault firstLayer


-- routerPush : Layer -> Router -> Router
-- routerPush nextLayer ( firstLayer, restLayers, animation ) =
--     ( firstLayer, restLayers ++ nextLayer )


-- routerPop : Router -> Router
-- routerPop ( firstLayer, restLayers ) =
--     ( firstLayer, List.drop 1 restLayers )
