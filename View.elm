module View where

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html exposing (Html)
import Model exposing (..)
import Debug exposing (log)
import Set


drawGrid : Float -> Float -> Html
drawGrid cameraWidth cameraHeight =
  image 
    [ xlinkHref "assets/grid.png"
    , x "0"
    , y "0"
    , width "1920"
    , height "1080"
    ] []

drawBackground : Float -> Float -> Html
drawBackground cameraWidth cameraHeight =
  rect 
    [ fill "#484"
    , x "0"
    , y "0"
    , width <| toString <| cameraWidth - 4 
    , height <| toString <| cameraHeight - 4 
    ] []


drawPlayer : Player -> Keys -> Html
drawPlayer player keysDown =
  let
    (w, h) = player.size
    (xPos, yPos) = player.pos
    angle = case player.dir of
      Down -> 0
      Left -> 90
      Up -> 180
      Right -> 270
    (anchorX, anchorY) = player.anchor
    offsetX = anchorX * toFloat w
    offsetY = anchorY * toFloat h
  in
    image
      [ xlinkHref "assets/snake.png"
      , x <| toString <| xPos - offsetX
      , y <| toString <| yPos - offsetY
      , width <| toString w
      , height <| toString h
      , transform ("rotate(" ++ (toString angle) ++ ", " ++ (toString xPos) ++ " " ++ (toString yPos) ++ ")")
      ]
      [ ]
  

view : Model -> Html
view model =
  let
    (cameraWidth, cameraHeight) = model.camera.size
  in
    svg
      [ x "0"
      , y "0"
      , width <| toString <| cameraWidth - 4
      , height <| toString <| cameraHeight - 4
      ]
      [ drawBackground cameraWidth cameraHeight
      , drawGrid cameraWidth cameraHeight
      , drawPlayer model.player model.keysDown
      ]
