module View (..) where

import Html exposing (text, Html)
import Html.Attributes exposing (href)
import Material.Color as Color
import Material exposing (lift, lift')
import Material.Style as Style
import Material.Layout as Layout
import Array exposing (Array)
import Actions exposing (..)
import Signal exposing (Address)
import Models exposing (Model)


header : List Html
header =
  [ Layout.title "elm-mdl"
  , Layout.spacer
  , Layout.navigation
      [ Layout.link
          [ href "https://www.getmdl.io/components/index.html" ]
          [ text "MDL" ]
      , Layout.link
          [ href "https://www.google.com/design/spec/material-design/introduction.html" ]
          [ text "Material Design" ]
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


tabViews : Array (Address -> Model -> List Html)
tabViews =
  List.map snd tabs |> Array.fromList


tabs =
  [-- [ ( "Snackbar"
   --   , \address model ->
   --       [ Demo.Snackbar.view (Signal.forwardTo addr SnackbarAction) model.snackbar ]
   --   )
   -- , ( "Textfields"
   --   , \addr model ->
   --       [ Demo.Textfields.view (Signal.forwardTo addr TextfieldAction) model.textfields ]
   --   )
   -- , ( "Buttons"
   --   , \addr model ->
   --       [ Demo.Buttons.view (Signal.forwardTo addr ButtonsAction) model.buttons ]
   --   )
   -- , ( "Grid", \addr model -> Demo.Grid.view )
   -- , ( "Badges", \addr model -> Demo.Badges.view )
   {-
   , ("Template", \addr model ->
       [Demo.Template.view (Signal.forwardTo addr TemplateAction) model.template])
   -}
  ]


view : Signal.Address Action -> Model -> Html
view address model =
  Layout.view
    (Signal.forwardTo address LayoutAction)
    model.layout
    { header =
        Just header
    , drawer =
        Just drawer
    , tabs = Nothing
    , main = [ stylesheet ]
    }
    |> Material.topWithScheme Color.Red Color.Red


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
