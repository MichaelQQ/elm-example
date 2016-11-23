module Main exposing (..)

import Html
import Messages exposing (Msg(..))
import Models exposing (Model, initialModel)
import Navigation exposing (Location)
import Routing exposing (Route)
import View exposing (view)
import Update exposing (update)
import Players.Commands exposing (fetchAll)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel currentRoute, Cmd.map PlayersMsg fetchAll )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- MAIN

main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
