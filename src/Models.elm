module Models (..) where

import Material.Layout as Layout
import Routing
import Player.Player as Player exposing (Player)


type alias Model =
  { layout : Layout.Model
  , routing : Routing.Model
  , player : Player
  , tabLength : Int
  }
