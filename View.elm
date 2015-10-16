module View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)
import Debug exposing (log)
import Dict


drawGrid : Int -> Int -> Html
drawGrid cameraWidth cameraHeight =
  div 
    [ style
        [ ("background-image", "url(assets/grid.png)")
        , ("position", "absolute")
        , ("left", "0px")
        , ("top", "0px")
        , ("background-color", "#484")
        , ("width", "1920px")
        , ("height", "1080px")
        ]
    ] []

drawPlayer : Player -> Keys -> Html
drawPlayer player keysDown =
  let (w, h) = player.size
      (xPos, yPos) = player.pos
      angle = case player.dir of
        Down -> 0
        Left -> 90
        Up -> 180
        Right -> 270
      (anchorX, anchorY) = player.anchor
      offsetX = anchorX * toFloat w
      offsetY = anchorY * toFloat h
      left = toString <| xPos - offsetX
      top = toString <| yPos - offsetY
      width = toString w
      height = toString h
  in
    div
      [ style
          [ ("background-image", "url(assets/snake-48dx48.png)")
          , ("position", "absolute")
          , ("left", left ++ "px")
          , ("top", top ++ "px")
          , ("width", width ++ "px")
          , ("height", height ++ "px")
          , ("z-index", "1000")
          ]
      ] []


drawTile : (Coords, Int) -> Html
drawTile ((x, y), tile) =
  div
    [ style
        [ ("position", "absolute")
        , ("left", toString (x * tileSize) ++ "px")
        , ("top", toString (y * tileSize) ++ "px")
        , ("width", toString tileSize ++ "px")
        , ("height", toString tileSize ++ "px")
        , ("background-color", if tile == 1 then "black" else "none")
        ]
    ] []


drawMap : Map -> Camera -> Html
drawMap map camera = 
  div 
    [ style
        [ ("position", "absolute")
        , ("left", "0px")
        , ("top", "0px")
        , ("width", "1920px")
        , ("height", "1080px")
        ]
    ] <| List.map drawTile (Dict.toList map.tiles)
    

view : Model -> Html
view model =
  let
    (cameraWidth, cameraHeight) = model.camera.size
  in
    div
      [ style
          [ ("position", "absolute")
          , ("top", "0px")
          , ("left", "0px")
          , ("width", toString cameraWidth ++ "px")
          , ("height", toString cameraHeight ++ "px")
          , ("overflow", "hidden")
          ]
      ]
      [ drawGrid cameraWidth cameraHeight
      , drawMap model.map model.camera
      , drawPlayer model.player model.keysDown
      ]
      --, rect [ x "100", y "100", width "100", height "100", Svg.Attributes.style "background-color: red" ] []
      --]
