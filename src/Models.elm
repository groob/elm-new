module Models (..) where

import Material.Layout as Layout
import Routing


type alias Model =
  { layout : Layout.Model
  , routing : Routing.Model
  }
