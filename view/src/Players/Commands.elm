module Players.Commands exposing (..)

import Http
import Json.Decode as Decode exposing (field)
import Json.Encode as Encode
import Players.Models exposing (PlayerId, Player)
import Players.Messages exposing (..)


fetchAll : Cmd Msg
fetchAll =
    Http.get fetchAllUrl collectionDecoder
        |> Http.send OnFetchAll


fetchAllUrl : String
fetchAllUrl =
    "http://localhost:4000/players"


collectionDecoder : Decode.Decoder (List Player)
collectionDecoder =
    Decode.list memberDecoder


memberDecoder : Decode.Decoder Player
memberDecoder =
    Decode.map3 Player
        (field "id" Decode.string)
        (field "name" Decode.string)
        (field "level" Decode.int)


saveUrl : PlayerId -> String
saveUrl playerId =
    "http://localhost:4000/players/" ++ playerId


save : Player -> Cmd Msg
save player =
    let
        body =
            memberEncoded player
                -- |> Encode.encode 0
                |> Http.jsonBody

        config =
            { method = "PATCH"
            , headers = []
            , url = saveUrl player.id
            , body = body
            , expect = Http.expectJson memberDecoder
            , timeout = Nothing
            , withCredentials = False
            }
    in
        Http.request config
            |> Http.send OnSave


memberEncoded : Player -> Encode.Value
memberEncoded player =
    let
        list =
            [ ( "id", Encode.string player.id )
            , ( "name", Encode.string player.name )
            , ( "level", Encode.int player.level )
            ]
    in
        list
            |> Encode.object
