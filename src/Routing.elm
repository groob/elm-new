module Routing (..) where

import Task exposing (Task)
import Effects exposing (Effects, Never)
import Hop
import Hop.Types exposing (Location, PathMatcher, Router, newLocation)
import Hop.Navigate exposing (navigateTo)
import Hop.Matchers exposing (match1, match2, match3, str)


type Route
  = HomeRoute
  | NotFoundRoute


type alias Model =
  { location : Location
  , route : Route
  }


initialModel : Model
initialModel =
  { location = newLocation
  , route = HomeRoute
  }


type Action
  = HopAction ()
  | ApplyRoute ( Route, Location )
  | NavigateTo String


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo path) )

    ApplyRoute ( route, location ) ->
      case route of
        _ ->
          ( { model | route = route, location = location }
          , Effects.none
          )

    HopAction () ->
      ( model, Effects.none )


indexMatcher : PathMatcher Route
indexMatcher =
  match1 HomeRoute "/"


matchers : List (PathMatcher Route)
matchers =
  [ indexMatcher
  ]


router : Router Route
router =
  Hop.new
    { matchers = matchers
    , notFound = NotFoundRoute
    }


run : Task () ()
run =
  router.run


signal : Signal Action
signal =
  Signal.map ApplyRoute router.signal
