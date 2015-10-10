module View where

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html exposing (Html)
import Model exposing (..)


drawBackground : Float -> Float -> Html
drawBackground cameraWidth cameraHeight =
  rect 
    [ fill "#484"
    , x "0"
    , y "0"
    , width <| toString <| cameraWidth - 4 
    , height <| toString <| cameraHeight - 4 
    ] []


drawPlayer : Player -> Html
drawPlayer player =
  let
    (width, height) = player.size
    (x, y) = player.pos
  in
    circle
      [ fill "#00F"
      , cx <| toString x
      , cy <| toString y
      , r <| toString <| width // 2
      ] []
  

view : Model -> Html
view model =
  let
    (cameraWidth, cameraHeight) = model.camera.size
  in
    svg
      [ version "1.1"
      , x "0"
      , y "0"
      , width <| toString <| cameraWidth - 4
      , height <| toString <| cameraHeight - 4
      ]
      [ drawBackground cameraWidth cameraHeight
      , drawPlayer model.player
      ]
