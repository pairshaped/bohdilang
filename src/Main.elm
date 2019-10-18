module Main exposing (..)

import Browser
import Helpers exposing (..)
import List.Extra
import RemoteData exposing (RemoteData(..))
import Types exposing (..)
import Views exposing (view)


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model flags 0 [] NotAsked "" "" False, getData flags.url )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotData data ->
            ( { model | data = data }, Cmd.none )

        Restart ->
            ( { model | input = "", output = "", score = 0 }, Cmd.none )

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
                words =
                    case model.data of
                        Success decodedData ->
                            decodedData.words

                        _ ->
                            []

                output =
                    case findEnTranslationFor words input of
                        Just found ->
                            if hasWordBeenCompleted model.completedWords found.en then
                                ""

                            else
                                found.en

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
