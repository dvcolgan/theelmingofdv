module Update where

import Model exposing (..)
import Debug exposing (log)
import Set exposing (member)
import Dict


-- UPDATE


coordsToPos : Coords -> Position
coordsToPos (col, row) =
  ( toFloat <| col * tileSize + tileSize // 2
  , toFloat <| row * tileSize + tileSize // 2
  )

movePosTowardsCoords : Position -> Coords -> Float -> Position
movePosTowardsCoords (x, y) coords speed =
  let
    (targetX, targetY) = coordsToPos coords
    dx = targetX - x
    dy = targetY - y
    dCol = if dx < 0 then -1 else if dx > 0 then 1 else 0
    dRow = if dy < 0 then -1 else if dy > 0 then 1 else 0
  in
    (x + dCol * speed, y + dRow * speed)


posIsAlignedToOrPastCoords : Position -> Coords -> Coords -> Bool
posIsAlignedToOrPastCoords (x, y) (prevCol, prevRow) (targetCol, targetRow) =
  let
    dCol = targetCol - prevCol
    dRow = targetRow - prevRow
    targetX = toFloat <| targetCol * tileSize + tileSize // 2
    targetY = toFloat <| targetRow * tileSize + tileSize // 2
  in
    if | dCol < 0 -> x <= targetX
       | dCol > 0 -> x >= targetX
       | dRow < 0 -> y <= targetY
       | dRow > 0 -> y >= targetY
       | otherwise -> True


alignToGrid : Coords -> Position -> Position
alignToGrid (col, row) (x, y) =
  ( toFloat <| col * tileSize + tileSize // 2
  , toFloat <| row * tileSize + tileSize // 2
  )


getDirectionalKeyStates : Keys -> (Bool, Bool, Bool, Bool)
getDirectionalKeyStates keysDown =
  ( member keys.left keysDown  || member keys.a keysDown
  , member keys.right keysDown || member keys.e keysDown     || member keys.d keysDown
  , member keys.up keysDown    || member keys.comma keysDown || member keys.w keysDown
  , member keys.down keysDown  || member keys.o keysDown     || member keys.s keysDown
  )


coordsArePassable : CollisionMap -> Coords -> Bool
coordsArePassable collision (col, row) =
  case Dict.get (col, row) collision of
    Nothing -> False
    Just tile -> log "tile" tile == 0


anyDirectionIsPressed : Keys -> Bool
anyDirectionIsPressed keysDown =
  let
    (left, right, up, down) = getDirectionalKeyStates keysDown
  in
    left || right || up || down



movePlayerTowardsTarget : Dt -> Player -> Player
movePlayerTowardsTarget dt player =
  { player
    | pos <- movePosTowardsCoords player.pos player.coords (player.speed)
  }


changePlayerDirection : Player -> Keys -> Player
changePlayerDirection player keysDown =
  let
    (nextCol, nextRow) = playerNextSquare player keysDown
    (col, row) = player.coords
  in
    { player
      | prevCoords <- (col, row)
      , coords <- (nextCol, nextRow)
    }


playerIsAlignedToOrPastCoords : Player -> Bool
playerIsAlignedToOrPastCoords player =
  posIsAlignedToOrPastCoords player.pos player.prevCoords player.coords


playerNextSquare : Player -> Keys -> Coords
playerNextSquare player keysDown =
  let
    (left, right, up, down) = getDirectionalKeyStates keysDown
    dCol = (if left then -1 else 0) + (if right then 1 else 0)
    dRow = (if up then -1 else 0) + (if down then 1 else 0)
    (col, row) = player.coords
  in
    (col + dCol, row + dRow)
    

playerNextSquareIsPassable : Player -> CollisionMap -> Keys -> Bool
playerNextSquareIsPassable player collision keysDown =
  playerNextSquare player keysDown
    |> coordsArePassable collision


stopPlayer : Player -> Player
stopPlayer player =
    { player
      | pos <- alignToGrid player.coords player.pos
      , moving <- False
      , prevCoords <- player.coords
    }


updatePlayer : Player -> CollisionMap -> Keys -> Dt -> Player
updatePlayer player collision keysDown dt =
  if | not (playerIsAlignedToOrPastCoords player) ->
        movePlayerTowardsTarget dt player
     | anyDirectionIsPressed keysDown && playerNextSquareIsPassable player collision keysDown ->
        changePlayerDirection player keysDown
          |> movePlayerTowardsTarget dt
     | otherwise ->
        stopPlayer player


update : Action -> Model -> Model
update action model =
  case action of

    NoOp ->
      model

    Tick dt ->
      { model | player <- updatePlayer model.player model.map.collision model.keysDown dt }

    KeysChanged keys ->
      { model | keysDown <- keys }
