module Main exposing (..)
import Browser
import Debug
import Array
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


--------------------------------------------------------------------------
-- MODEL
--------------------------------------------------------------------------

type alias Model =
  { cardIndex: Int
  , cards: List Card
  }

-- init : Model
init =
    { cardIndex = 0
    , cards = allCards
    }

type Msg =
  PreviousCard
  | NextCard
  --| Flip


--------------------------------------------------------------------------
-- UPDATE
--------------------------------------------------------------------------

update : Msg -> Model -> Model
update msg model =
  case msg of
    PreviousCard ->
      { model | cardIndex = max (model.cardIndex - 1) 0 }
    NextCard ->
        let maximum = List.length(model.cards) - 1
        in
            { model | cardIndex = min (model.cardIndex + 1) maximum }

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
  in
      div [ class "c-flash" ]
        [ div [ class "c-flash__info" ]
          [ span [ class "c-flash__card-name" ] [ text card.name  ]
        ]
        , div []
          [ img
            [ src ("/images/" ++ card.name ++ "_back.JPG")
            , class "c-flash__card-back"
            ]
            []
          ]
        , div [ class "c-flash__controls" ]
            [ button [ onClick PreviousCard
              , class (if isFirstCard then "disabled" else "")
              , disabled isFirstCard
            ] [ text "< Previous" ]
            , span [class "c-flash__indicator" ]
                [ text (cardNumber ++ " / " ++ totalCards) ]
            , button [ onClick NextCard
              , class (if isLastCard then "disabled" else "")
              , disabled isLastCard
            ] [ text "Next >" ]
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
