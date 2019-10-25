module Types exposing (..)


type Msg
    = Restart
    | ToggleWords
    | NextQuestion (List Int)
    | Answer (Maybe Word)


type alias Model =
    { right : Bool
    , wrong : Bool
    , score : Int
    , question : Maybe Word
    , answers : List (Maybe Word)
    , showWords : Bool
    }


type alias Word =
    ( String, String )
