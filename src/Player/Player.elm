module Player.Player (..) where

import Effects exposing (Effects, Never)
import Html exposing (Html, div, text)
import Html.Attributes exposing (..)
import Material.Textfield as Textfield


-- MODEL


type alias Player =
  { name : Textfield.Model
  , age : Int
  }


initialModel =
  let
    t0 =
      Textfield.model
  in
    { name = { t0 | value = "Abe" }
    , age = 42
    }



-- ACTION


type Action
  = NoOp
  | TextfieldAction Textfield.Action



-- update : Action -> ViewModel -> ( ViewModel, Effects Action )


update action model =
  case (Debug.log "action" action) of
    TextfieldAction subAction ->
      let
        updatedField =
          model.name
            |> Textfield.update subAction
      in
        ( { model | name = updatedField }, Effects.none )

    NoOp ->
      ( model, Effects.none )


br =
  Html.br [] []


view address model =
  div
    [ class "player-widget" ]
    [ -- [ Textfield.view (Signal.forwardTo address TextfieldAction) model
      Textfield.view (Signal.forwardTo address TextfieldAction) model.name
    , text model.name.value
    ]
