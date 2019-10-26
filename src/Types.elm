module Types exposing (..)


type Msg
    = Restart
    | ToggleWords
    | NextQuestion (List Int)
    | Answer (Maybe Word)


type alias Model =
    { wordsRemaining : List Word
    , wordsAnswered : List WordAnswered
    , correct : Maybe Bool
    , score : Int
    , question : Maybe Word
    , answers : List (Maybe Word)
    , showWords : Bool
    , finished : Bool
    }


type alias WordAnswered =
    { word : Word
    , correct : Bool
    }


gameLength : Int
gameLength =
    20


type alias Word =
    ( String, String )
