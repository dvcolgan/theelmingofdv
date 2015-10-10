module Main where

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html exposing (Html)

import Debug exposing (log, crash)
import Signal
import Time
import Window
import Keyboard
import StartApp.Simple


-- MODEL

tileSize : Int
tileSize = 64


type alias Keys = { x : Int, y : Int }


type alias Dt = Time.Time
type alias Position = (Float, Float)
type alias Coords = (Int, Int)
type alias Size = (Int, Int)


type alias Camera =
  { pos : Position
  , size : Size
  }


type alias KeysDown =
  { left : Bool
  , right : Bool
  , up : Bool
  , down : Bool
  }


initCamera : Camera
initCamera =
  { pos = (0.0, 0.0)
  , size = (1000, 800)
  }


type alias Player =
  { pos : Position -- x,y position
  , coords : Coords -- col,row position
  , size : Size
  , moving : Bool
  , speed : Float
  }


initPlayer : Player
initPlayer =
  { pos = (0.0, 0.0)
  , coords = (0, 0)
  , size = (32, 32)
  , moving = False
  , speed = 4.0
  }


type alias Model =
  { player : Player
  , camera : Camera
  , keysDown : KeysDown
  }


initModel : Model
initModel =
  { player = initPlayer
  , camera = initCamera
  }


type Action
  = NoOp
  | Tick Dt
  | KeysChanged Keys
  | ResizeWindow Size


-- UPDATE

lerp : Float -> Float -> Dt -> Float
lerp start end dt =
  (1 - dt) * start + dt * end


updatePlayer : Player -> Dt -> Player
{-
updatePlayer player dt =
  let
    (col, row) = player.coords
    newX = toFloat <| col * tileSize
    newY = toFloat <| row * tileSize
  in
    { player | pos <- (newX, newY) }
-}
updatePlayer player dt =
  let
    (x, y) = player.pos
    (col, row) = player.coords
    targetX = toFloat <| col * tileSize
    targetY = toFloat <| row * tileSize
    newX = lerp x targetX dt
    newY = lerp y targetY dt
  in
    { player
      | pos <- (newX, newY)
      , moving <- log "moving" ((floor x) == (floor newX) && (floor y == floor newY))
    }


movePlayer : Player -> Keys -> Player
movePlayer player keys =
  if player.moving then
    let
      (col, row) = player.coords
    in
      { player
        | coords <- (col + keys.x, row - keys.y) 
        , moving <- True
      }
  else
    player


resizeCamera : Camera -> Size -> Camera
resizeCamera camera size =
  { camera | size <- size }

update : Action -> Model -> Model
update action model =
  case action of

    NoOp ->
      model

    Tick dt ->
      { model | player <- updatePlayer model.player (log "TD" dt) }

    KeysChanged keys ->
      { model | player <- movePlayer model.player keys }

    ResizeWindow size ->
      { model | camera <- resizeCamera model.camera size }


-- VIEW

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


-- SIGNALS

input : Signal Action
input =
  Signal.mergeMany 
    [ Signal.map KeysChanged Keyboard.arrows
    , Signal.map (\dt -> Tick (dt / 1000)) (Time.fps 60)
    , Signal.map ResizeWindow Window.dimensions
    ]

model : Signal Model
model =
  Signal.foldp update initModel input


main : Signal Html
main =
  Signal.map view model
