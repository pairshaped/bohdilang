module Types exposing (..)

import Json.Decode as Decode exposing (Decoder, bool, int, list, nullable, string)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Json.Encode as Encode
import Json.Encode.Extra exposing (maybe)
import RemoteData exposing (WebData)


type Msg
    = GotData (WebData Data)
    | Translate String
    | Restart
    | ToggleWords


type alias Model =
    { flags : Flags
    , score : Int
    , completedWords : List String
    , data : WebData Data
    , input : String
    , output : String
    , showWords : Bool
    }


type alias Flags =
    { url : String
    }


type alias Data =
    { words : List Word
    }


type alias Word =
    { en : String
    , bd : String
    }


dataDecoder : Decoder Data
dataDecoder =
    Decode.succeed Data
        |> required "words" (list wordDecoder)


wordDecoder : Decoder Word
wordDecoder =
    Decode.succeed Word
        |> required "en" string
        |> required "bd" string


encodeWord : Word -> Encode.Value
encodeWord word =
    Encode.object
        [ ( "en", Encode.string word.en )
        , ( "bd", Encode.string word.bd )
        ]
