module Types exposing (..)


type Msg
    = Translate String
    | Restart
    | ToggleWords


type alias Model =
    { score : Int
    , completedWords : List String
    , input : String
    , output : String
    , showWords : Bool
    }


type alias Word =
    ( String, String )
