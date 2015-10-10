module Model where

import Time
import Set exposing (Set)
import Keyboard exposing (KeyCode)


tileSize : Int
tileSize = 64


type alias Keys = Set KeyCode


type alias Dt = Time.Time
type alias Position = (Float, Float)
type alias Coords = (Int, Int)
type alias Size = (Int, Int)


type alias Camera =
  { pos : Position
  , size : Size
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
  , keysDown : Keys
  }


initModel : Model
initModel =
  { player = initPlayer
  , camera = initCamera
  , keysDown = Set.empty
  }


type Action
  = NoOp
  | Tick Dt
  | KeysChanged Keys
  | ResizeWindow Size


