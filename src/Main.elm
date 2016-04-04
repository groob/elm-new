module Main (..) where

import Html exposing (Html)
import Effects exposing (Effects, Never)
import Task exposing (Task)
import Signal exposing (Address)
import StartApp
import Routing
import View exposing (..)
import Material.Layout as Layout exposing (defaultLayoutModel)
import Player.Player as Player


-- App Imports

import Update exposing (update)
import Actions exposing (..)
import Models exposing (Model)


-- MODEL


initialModel : Model
initialModel =
  { layout = (layoutModel 3)
  , routing = Routing.initialModel
  , player = Player.initialModel
  , tabLength = 2
  }


layoutModel : Int -> Layout.Model
layoutModel length =
  { defaultLayoutModel
    | state = Layout.initState (length)
  }


init : ( Model, Effects Action )
init =
  ( initialModel
  , Effects.none
  )



-- INPUTS


inputs : List (Signal.Signal Action)
inputs =
  [ layoutSignal
  , routerSignal
  ]


layoutSignal : Signal Action
layoutSignal =
  Layout.setupSizeChangeSignal LayoutAction


routerSignal : Signal Action
routerSignal =
  Signal.map RoutingAction Routing.signal



-- APP


app =
  StartApp.start
    { init = init
    , view = view
    , update = update
    , inputs = inputs
    }


main : Signal Html
main =
  app.html



-- PORTS


port routeRunTask : Task () ()
port routeRunTask =
  Routing.run


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
