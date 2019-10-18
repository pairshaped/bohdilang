module Main exposing (..)

import Browser
import Helpers exposing (..)
import List.Extra
import Types exposing (..)
import Views exposing (view)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 0 [] "" "" False, Cmd.none )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Restart ->
            ( { model | input = "", output = "", score = 0, completedWords = [] }, Cmd.none )

        ToggleWords ->
            let
                score =
                    if model.showWords then
                        model.score

                    else
                        model.score - 2
            in
            ( { model | showWords = not model.showWords, score = score }, Cmd.none )

        Translate input ->
            let
                output =
                    case findTranslationFor input of
                        Just found ->
                            if hasWordBeenCompleted model.completedWords (Tuple.second found) then
                                ""

                            else
                                Tuple.second found

                        Nothing ->
                            ""

                score =
                    if output /= "" then
                        model.score + 1

                    else
                        model.score

                completedWords =
                    if output /= "" then
                        output :: model.completedWords

                    else
                        model.completedWords
            in
            ( { model | input = input, output = output, score = score, completedWords = completedWords }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- RUN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
