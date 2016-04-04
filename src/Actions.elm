module Actions (..) where

import Material.Layout as Layout
import Routing
import Player.Player as Player


type Action
  = LayoutAction Layout.Action
  | RoutingAction Routing.Action
  | PlayerAction Player.Action
