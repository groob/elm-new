module DOM
  ( target, offsetParent
  , offsetWidth, offsetHeight
  , offsetLeft, offsetTop
  , scrollLeft, scrollTop
  , Rectangle, boundingClientRect
  ) where

{-| You read values off the DOM by constructing a JSON decoder.
See the `target` value for example use.

# Traversing the DOM
@docs target, offsetParent

# Geometry
Decoders for reading sizing etc. properties off the DOM. All decoders return
measurements in pixels.

Refer to, e.g.,
[the Mozilla documentation](https://developer.mozilla.org/en-US/docs/Web/API/CSS_Object_Model/Determining_the_dimensions_of_elements)
for the precise semantics of these measurements. See also
[this stackoverflow answer](https://stackoverflow.com/questions/294250/how-do-i-retrieve-an-html-elements-actual-width-and-height).

@docs offsetWidth, offsetHeight
@docs offsetLeft, offsetTop
@docs Rectangle, boundingClientRect

# Scroll
@docs scrollLeft, scrollTop
-}

import Json.Decode as Json exposing ((:=), andThen)


{-| Get the target DOM element of an event. You will usually start with this
decoder. E.g., to make a button which when clicked emit an Action that carries
the width of the button:

    import DOM exposing (target, offsetWidth)

    type Action = Click Float

    myButton : Signal.Address Action -> Html
    myButton addr =
      button
        [ on "click" (target offsetWidth) (Click >> Signal.message addr) ]
        [ text "Click me!" ]
-}
target : Json.Decoder a -> Json.Decoder a
target decoder =
  "target" := decoder


{-| Get the parent of the current element. Returns first argument if the current
element is already the root; applies the second argument to the parent element
if not.

To do traversals of the DOM, exploit that Elm allows recursive values. See
an example
[here](https://github.com/debois/elm-dom/blob/master/src/DOM.elm#L165-L176).
-}
offsetParent : a -> Json.Decoder a -> Json.Decoder a
offsetParent x decoder =
  Json.oneOf
  [ "offsetParent" := Json.null x
  , "offsetParent" := decoder
  ]



{-| Get the width of an element in pixels; underlying implementation
reads `.offsetWidth`.
-}
offsetWidth : Json.Decoder Float
offsetWidth = "offsetWidth" := Json.float


{-| Get the heigh of an element in pixels. Underlying implementation
reads `.offsetHeight`.
-}
offsetHeight : Json.Decoder Float
offsetHeight = "offsetHeight" := Json.float


{-| Get the left-offset of the element in the parent element in pixels.
Underlying implementation reads `.offsetLeft`.
-}
offsetLeft : Json.Decoder Float
offsetLeft = "offsetLeft" := Json.float


{-| Get the top-offset of the element in the parent element in pixels.
Underlying implementation reads `.offsetTop`.
-}
offsetTop : Json.Decoder Float
offsetTop = "offsetTop" := Json.float


{-| Get the amount of left scroll of the element in pixels.
Underlying implementation reads `.scrollLeft`.
-}
scrollLeft : Json.Decoder Float
scrollLeft = "scrollLeft" := Json.float


{-| Get the amount of top scroll of the element in pixels.
Underlying implementation reads `.scrollTop`.
-}
scrollTop : Json.Decoder Float
scrollTop = "scrollTop" := Json.float


{-| Types for rectangles.
-}
type alias Rectangle =
  { top : Float
  , left : Float
  , width : Float
  , height : Float
  }


{-| Approximation of the method
[getBoundingClientRect](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XPCOM/Reference/Floaterface/nsIDOMClientRect),
based off
[this stackoverflow answer](https://stackoverflow.com/questions/442404/retrieve-the-position-x-y-of-an-html-element).

NB! This decoder is likely computationally expensive and may produce results
that differ slightly from `getBoundingClientRect` in browser-dependent ways.

(I don't get to call getBoundingClientRect directly from Elm without going
native or using ports; my packages don't get to go native and I can find no
solution with ports. So we do it like in the bad old days with an O(lg n)
traversal of the DOM, only now through presumably expensive JSON decoders.
It's 2007 forever, baby!)
-}
boundingClientRect : Json.Decoder Rectangle
boundingClientRect =
  Json.object3
    (\(x, y) width height ->
      { top = y
      , left = x
      , width = width
      , height = height
      })
    (position 0 0)
    offsetWidth
    offsetHeight


{- This is what we're implementing (from the above link).

    function getOffset( el ) {
        var _x = 0;
        var _y = 0;
        while( el && !isNaN( el.offsetLeft ) && !isNaN( el.offsetTop ) ) {
            _x += el.offsetLeft - el.scrollLeft;
            _y += el.offsetTop - el.scrollTop;
            el = el.offsetParent;
        }
        return { top: _y, left: _x };
    }
    var x = getOffset( document.getElementById('yourElId') ).left; )
-}
position : Float -> Float -> Json.Decoder (Float, Float)
position x y =
  Json.object4
    (\scrollLeft scrollTop offsetLeft offsetTop ->
      (x + offsetLeft - scrollLeft, y + offsetTop - scrollTop))
    scrollLeft
    scrollTop
    offsetLeft
    offsetTop
  `andThen` (\(x',y') ->
    offsetParent (x', y') (position x' y')
  )
