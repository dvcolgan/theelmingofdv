module Main where

import Debug exposing (log, crash)
import Signal
import Time
import Window
import Keyboard
import StartApp.Simple

import Model exposing (..)
import View exposing (view)
import Update exposing (update)
import Html exposing (Html)


input : Signal Action
input =
  Signal.mergeMany 
    [ Signal.map KeysChanged Keyboard.keysDown
    , Signal.map (\dt -> Tick (dt / 1000)) (Time.fps 60)
    --, Signal.map ResizeWindow Window.dimensions
    ]

model : Signal Model
model =
  Signal.foldp update initModel input


main : Signal Html
main =
  Signal.map view model
