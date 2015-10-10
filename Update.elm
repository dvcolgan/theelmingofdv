module Update where

import Model exposing (..)
import Debug exposing (log)
import Set exposing (member)

-- UPDATE

lerp : Float -> Float -> Dt -> Float
lerp start end dt =
  (1 - dt) * start + dt * end


updatePlayer : Player -> Keys -> Dt -> Player
{-
updatePlayer player dt =
  let
    (col, row) = player.coords
    newX = toFloat <| col * tileSize
    newY = toFloat <| row * tileSize
  in
    { player | pos <- (newX, newY) }
-}
updatePlayer player keysDown dt =
  let
    left = member 37 keysDown
    right = member 39 keysDown
    up = member 38 keysDown
    down = member 40 keysDown

    dx = (if left then -1 else 0) + (if right then 1 else 0)
    dy = (if up then -1 else 0) + (if down then 1 else 0)

    (x, y) = player.pos
    --(col, row) = player.coords
    --targetX = toFloat <| col * tileSize
    --targetY = toFloat <| row * tileSize
    --newX = lerp x targetX dt
    --newY = lerp y targetY dt
  in
    { player
      | pos <- (x + dx, y + dy)
      --, moving <- (floor x) == (floor newX) && (floor y == floor newY)
    }


--movePlayer : Player -> Keys -> Player
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
      { model | player <- updatePlayer model.player model.keysDown dt }

    KeysChanged keys ->
      { model | keysDown <- keys }

    ResizeWindow size ->
      { model | camera <- resizeCamera model.camera size }


