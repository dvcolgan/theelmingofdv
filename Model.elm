module Model where

import Time
import Set exposing (Set)
import Keyboard exposing (KeyCode)


tileSize : Int
tileSize = 64

keys =
  { left = 37
  , right = 39
  , up = 38
  , down = 40
  , w = 87
  , s = 83
  , d = 68
  , a = 65
  , o = 79
  , e = 69
  , comma = 188
  , space = 32
  }


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


type Direction = Left | Right | Up | Down

type alias Player =
  { pos : Position -- x,y position
  , coords : Coords -- col,row position
  , prevCoords : Coords
  , dir : Direction
  , anchor : (Float, Float)
  , size : Size
  , moving : Bool
  , speed : Float
  }


initPlayer : Player
initPlayer =
  { pos = (32, 32)
  , coords = (0, 0)
  , prevCoords = (0, 0)
  , dir = Down
  , anchor = (0.5, 0.5)
  , size = (48, 48)
  , moving = False
  , speed = 2.0
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


