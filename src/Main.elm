module Main exposing (..)
import Browser
import Debug
import Array
import Time
import Random
import Random.List
import Html exposing (Html, button, img, div, text, span)
import Html.Attributes exposing (class, src, id, disabled)
import Html.Events exposing (onClick)


--------------------------------------------------------------------------
-- Custom Data
--------------------------------------------------------------------------

type alias Card =
  { name: String
  }

defaultCard = Card "C4"

allCards =
  [ defaultCard
  , Card "A2"
  , Card "A3"
  , Card "A4"
  , Card "A5"
  , Card "A6"
  , Card "B2"
  , Card "B3"
  , Card "B4"
  , Card "B5"
  , Card "B6"
  , Card "C2"
  , Card "C3"
  , Card "C4"
  , Card "C5"
  , Card "C6"
  , Card "D2"
  , Card "D3"
  , Card "D4"
  , Card "D5"
  , Card "D6"
  , Card "E2"
  , Card "E3"
  , Card "E4"
  , Card "E5"
  , Card "E6"
  , Card "F2"
  , Card "F3"
  , Card "F4"
  , Card "F5"
  , Card "F6"
  , Card "G2"
  , Card "G3"
  , Card "G4"
  , Card "G5"
  , Card "G6"
  ]

getCard : Model -> Card
getCard model =
    let
        cards = Array.fromList model.cards
        card = Array.get model.cardIndex cards
    in
        case card of
            Just t -> t
            Nothing -> defaultCard

shuffleCards : List Card -> List Card
shuffleCards deck =
    let
        shuffledCards = Random.List.shuffle deck
    in
        Random.step shuffledCards (Random.initialSeed 123)
            |> Tuple.first

--------------------------------------------------------------------------
-- MODEL
--------------------------------------------------------------------------

type alias Model =
  { cardIndex: Int
  , cards: List Card
  , isFlipped: Bool
  }

-- init : Model
init =
    { cardIndex = 0
    , cards = shuffleCards allCards
    , isFlipped = False
    }

type Msg =
  PreviousCard
  | NextCard
  | Flip
  | Reset


--------------------------------------------------------------------------
-- UPDATE
--------------------------------------------------------------------------

update : Msg -> Model -> Model
update msg model =
  case msg of
    PreviousCard ->
      { model | isFlipped = False
      , cardIndex = max (model.cardIndex - 1) 0
      }
    NextCard ->
        let maximum = List.length(model.cards) - 1
        in
            { model | isFlipped = False
            , cardIndex = min (model.cardIndex + 1) maximum
            }
    Flip ->
        { model | isFlipped = not model.isFlipped }
    Reset ->
        { model | cards = shuffleCards model.cards
        , isFlipped = False
        }

--------------------------------------------------------------------------
-- VIEW
--------------------------------------------------------------------------

view : Model -> Html Msg
view model =
  let
      card = getCard(model)
      cardNumber = String.fromInt (model.cardIndex + 1)
      totalCards = String.fromInt (List.length model.cards)
      isFirstCard = model.cardIndex == 0
      isLastCard = cardNumber == totalCards
      face = if model.isFlipped then "back" else "front"
  in
      div [
          class (if model.isFlipped then "c-flash c-flash--flipped" else "c-flash")
          ]
          -- Card Graphic
          [ div []
              [ img
                  [ src ("/images/" ++ card.name ++ "_" ++ face ++ ".JPG")
                  , class "c-flash__card-back"
                  ] []
              ]
          -- Controls and Index indication
          , div [ class "c-flash__controls" ]
              [ button [ onClick PreviousCard
                , class (if isFirstCard then "disabled" else "")
                , disabled isFirstCard
              ] [ text "< Previous" ]
              , span [class "c-flash__indicator" ] [
                  text (cardNumber ++ " / " ++ totalCards) ]
              , button [ onClick NextCard
                    , class (if isLastCard then "disabled" else "")
                    , disabled isLastCard
              ] [ text "Next >" ]
              , button [ class "u-loud", onClick Flip ] [ text "Flip!" ]
              , button [ onClick Reset ] [ text "Reset" ]
            ]
          -- Hidden details
          , div [ class "c-flash__info" ]
                  [ span [ class "c-flash__card-name" ] [ text card.name  ]
              ]
          ]

--------------------------------------------------------------------------
-- MAIN
--------------------------------------------------------------------------

main : Program () Model Msg
main =
    Browser.sandbox
        { view = view
        , init = init
        , update = update
        }
