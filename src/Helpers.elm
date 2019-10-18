module Helpers exposing (..)

import List.Extra
import RemoteData exposing (RemoteData(..))
import RemoteData.Http
import Types exposing (..)


getData : String -> Cmd Msg
getData url =
    RemoteData.Http.get (url ++ "/db") GotData dataDecoder


findEnTranslationFor : List Word -> String -> Maybe Word
findEnTranslationFor words input =
    List.Extra.find (\w -> String.toLower w.bd == String.toLower input) words


hasWordBeenCompleted : List String -> String -> Bool
hasWordBeenCompleted completedWords word =
    case List.Extra.find (\w -> w == word) completedWords of
        Just _ ->
            True

        Nothing ->
            False
