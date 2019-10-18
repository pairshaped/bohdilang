module Helpers exposing (..)

import List.Extra
import Types exposing (..)
import Words exposing (words)


findTranslationFor : String -> Maybe Word
findTranslationFor input =
    List.Extra.find (\w -> String.toLower (Tuple.first w) == String.toLower input) words


hasWordBeenCompleted : List String -> String -> Bool
hasWordBeenCompleted completedWords word =
    case List.Extra.find (\w -> w == word) completedWords of
        Just _ ->
            True

        Nothing ->
            False
