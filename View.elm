module View where

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html exposing (Html)
import Model exposing (..)
import Set


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
  in
    image
      [ xlinkHref "/assets/snake.png"
      , x <| toString xPos
      , y <| toString yPos
      , width "32px"
      , height "32px"
      , transform ("rotate(" ++ (toString angle) ++ ", " ++ (toString <| xPos + 16) ++ " " ++ (toString <| yPos + 16) ++ ")")
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
      , drawPlayer model.player model.keysDown
      ]
