module Actions (..) where

import Material.Layout as Layout
import Routing


type Action
  = LayoutAction Layout.Action
  | RoutingAction Routing.Action
