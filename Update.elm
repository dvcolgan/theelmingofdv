module Update where

import Model exposing (..)
import Debug exposing (log)
import Set exposing (member)

-- UPDATE

lerp : Float -> Float -> Dt -> Float
lerp start end dt =
  (1 - dt) * start + dt * end


playerIsAlignedOrPast : Player -> Bool
playerIsAlignedOrPast player =
  let
    (prevCol, prevRow) = player.prevCoords
    (col, row) = player.coords
    dx = col - prevCol
    dy = row - prevRow
    (xPos, yPos) = player.pos
    targetX = toFloat <| col * tileSize + tileSize // 2
    targetY = toFloat <| row * tileSize + tileSize // 2
  in
    if | dx < 0 -> xPos <= targetX
       | dx > 0 -> xPos >= targetX
       | dy < 0 -> yPos <= targetY
       | dy > 0 -> yPos >= targetY
       | otherwise -> True


updatePlayer : Player -> Keys -> Dt -> Player
updatePlayer player keysDown dt =
  if not player.moving || playerIsAlignedOrPast player then
    -- Check if a key is down, if so go in that direction
    let
      left = (member keys.left keysDown) || (member keys.a keysDown)
      right = (member keys.right keysDown) || (member keys.e keysDown) || (member keys.d keysDown)
      up = (member keys.up keysDown) || (member keys.comma keysDown) || (member keys.w keysDown)
      down = (member keys.down keysDown) || (member keys.o keysDown) || (member keys.s keysDown)
    in
      -- If no key is pressed, stop and be aligned to the grid
      if (not left) && (not right) && (not up) && (not down) then
        let
          (col, row) = player.coords
        in
          { player
            | moving <- False
            , pos <-
              ( toFloat <| col * tileSize + tileSize // 2
              , toFloat <| row * tileSize + tileSize // 2
              )
          }
      -- Otherwise continue going in the new direction
      else
        let
          dx = (if left then -1 else 0) + (if right then 1 else 0)
          dy = (if up then -1 else 0) + (if down then 1 else 0)

          newDir = if | left -> Left
                      | right -> Right
                      | up -> Up
                      | down -> Down
                      | otherwise -> player.dir
          
          (x, y) = player.pos
          (col, row) = player.coords
        in
          { player
            | pos <- (x + dx * player.speed, y + dy * player.speed)
            , prevCoords <- (col, row)
            , coords <- (col + dx, row + dy)
            , moving <- True
            , dir <- newDir
          }
  else
    -- Just continue in the direction we are going
    let
      (x, y) = player.pos
      newPos = case player.dir of
        Left -> (x - player.speed, y)
        Right -> (x + player.speed, y)
        Up -> (x, y - player.speed)
        Down -> (x, y + player.speed)
    in
      { player | pos <- newPos }


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


