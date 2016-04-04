module View (..) where

import Html exposing (text, div, Html)
import Html.Attributes exposing (href, style)
import Material.Color as Color
import Material exposing (lift, lift')
import Material.Style as Style
import Material.Layout as Layout
import Array exposing (Array)
import Actions exposing (..)
import Signal exposing (Address)
import Models exposing (Model)
import Player.Player as Player


header : List Html
header =
  [ Layout.title "My Elm App"
  , Layout.spacer
  , Layout.navigation
      [ Layout.link
          [ href "https://www.getmdl.io/components/index.html" ]
          [ text "MDL" ]
      , Layout.link
          [ href "https://www.google.com/design/spec/material-design/introduction.html" ]
          [ text "Material _Design" ]
      ]
  ]


drawer : List Html
drawer =
  [ Layout.title "Example drawer"
  , Layout.navigation
      [ Layout.link
          [ href "https://github.com/debois/elm-mdl" ]
          [ text "github" ]
      , Layout.link
          [ href "http://package.elm-lang.org/packages/debois/elm-mdl/latest/" ]
          [ text "elm-package" ]
      , Layout.link
          [ href "http://package.elm-lang.org/packages/debois/elm-mdl/latest/" ]
          [ text "elm-package" ]
      ]
  ]


tabViews : Array (Address Action -> Model -> List Html)
tabViews =
  List.map snd tabs |> Array.fromList


tabTitles : List Html
tabTitles =
  List.map (fst >> text) tabs


tabs =
  [ ( "Player"
    , \address model -> [ Player.view (Signal.forwardTo address PlayerAction) model.player ]
    )
  ]


view : Signal.Address Action -> Model -> Html
view address model =
  let
    top =
      div
        [ style
            [ ( "margin", "auto" )
            , ( "padding-left", "5%" )
            , ( "padding-right", "5%" )
            ]
        ]
        ((Array.get model.layout.selectedTab tabViews
            |> Maybe.withDefault
                (\address model ->
                  [ div [] [ text "This can't happen." ] ]
                )
         )
          address
          model
        )
  in
    Layout.view
      (Signal.forwardTo address LayoutAction)
      model.layout
      { header =
          Just header
      , drawer =
          Just drawer
      , tabs = Just tabTitles
      , main = [ stylesheet, top ]
      }



-- |> Material.top


stylesheet : Html
stylesheet =
  Style.stylesheet """
  blockquote:before { content: none; }
  blockquote:after { content: none; }
  blockquote {
    border-left-style: solid;
    border-width: 1px;
    padding-left: 1.3ex;
    border-color: rgb(255,82,82);
    font-style: normal;
      /* TODO: Really need a way to specify "secondary color" in
         inline css.
       */
  }
  p, blockquote {
    max-width: 33em;
    font-size: 13px;
  }
"""
