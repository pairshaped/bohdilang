module Types exposing (..)


type Msg
    = Restart
    | ToggleWords
    | NextQuestion (List Int)
    | Answer (Maybe Word)


type alias Model =
    { wordsRemaining : List Word
    , correct : Maybe Bool
    , score : Int
    , question : Maybe Word
    , answers : List (Maybe Word)
    , showWords : Bool
    , finished : Bool
    }


type alias Word =
    ( String, String )
