module Main exposing (..)

import Browser
import List.Extra
import Random
import Types exposing (..)
import Views exposing (view)
import Words exposing (words)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model False False 0 Nothing [] False, Random.generate NextQuestion (Random.list 4 (Random.int 0 (List.length words))) )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Restart ->
            ( { model | question = Nothing, answers = [], score = 0 }, Cmd.none )

        ToggleWords ->
            let
                score =
                    if model.showWords then
                        model.score

                    else
                        model.score - 2
            in
            ( { model | showWords = not model.showWords, score = score }, Cmd.none )

        NextQuestion numbers ->
            let
                question =
                    case List.head numbers of
                        Just index ->
                            List.Extra.getAt index words

                        Nothing ->
                            model.question

                answer index =
                    List.Extra.getAt index words

                answers =
                    List.map answer numbers
            in
            ( { model | question = question, answers = answers }, Cmd.none )

        Answer word ->
            let
                right =
                    word == model.question

                wrong =
                    not right

                score =
                    if right then
                        model.score + 1

                    else
                        model.score
            in
            ( { model | right = right, wrong = wrong, score = score }, Random.generate NextQuestion (Random.list 4 (Random.int 0 (List.length words - 1))) )



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
