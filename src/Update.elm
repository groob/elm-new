module Update (..) where

import Routing
import Actions exposing (..)
import Material exposing (lift, lift')
import Effects exposing (Effects, Never)
import Models exposing (Model)
import Material.Layout as Layout


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    LayoutAction subAction ->
      lift .layout (\m x -> { m | layout = x }) LayoutAction Layout.update subAction model

    RoutingAction subAction ->
      let
        ( updatedRouting, fx ) =
          Routing.update subAction model.routing

        updatedModel =
          { model | routing = updatedRouting }
      in
        ( updatedModel, Effects.map RoutingAction fx )
