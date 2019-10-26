module Main exposing (..)

import Browser
import List.Extra
import Random
import Types exposing (..)
import Views exposing (view)
import Words exposing (words)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model words [] Nothing 0 Nothing [] False False, Random.generate NextQuestion (randomize words) )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Restart ->
            ( { model | wordsRemaining = words, question = Nothing, answers = [], finished = False, score = 0, correct = Nothing }
            , Random.generate NextQuestion (randomize model.wordsRemaining)
            )

        ToggleWords ->
            let
                score =
                    if model.showWords then
                        model.score

                    else
                        model.score - 2
            in
            ( { model | showWords = not model.showWords, score = score }, Cmd.none )

        NextQuestion randomIndexes ->
            let
                answer index =
                    List.Extra.getAt index model.wordsRemaining

                answers =
                    case List.tail randomIndexes of
                        Just tail ->
                            List.map answer tail

                        Nothing ->
                            model.answers

                question =
                    case List.head randomIndexes of
                        Just head ->
                            case List.Extra.getAt head answers of
                                Just word ->
                                    word

                                Nothing ->
                                    Nothing

                        Nothing ->
                            Nothing

                finished =
                    List.length model.wordsRemaining <= 4

                correct =
                    if finished then
                        Nothing

                    else
                        model.correct
            in
            ( { model | question = question, answers = answers, finished = finished, correct = correct }, Cmd.none )

        Answer word ->
            let
                correct =
                    Just (word == model.question)

                score =
                    case correct of
                        Just True ->
                            model.score + 1

                        _ ->
                            model.score

                filterWord w =
                    case model.question of
                        Just question ->
                            w /= question

                        Nothing ->
                            False

                wordsRemaining =
                    List.filter filterWord model.wordsRemaining

                wordsAnswered =
                    case model.question of
                        Just question ->
                            List.append
                                model.wordsAnswered
                                [ WordAnswered question
                                    (case correct of
                                        Just cor ->
                                            cor

                                        Nothing ->
                                            False
                                    )
                                ]

                        Nothing ->
                            model.wordsAnswered
            in
            ( { model | wordsAnswered = wordsAnswered, wordsRemaining = wordsRemaining, correct = correct, score = score }
            , Random.generate NextQuestion (randomize wordsRemaining)
            )


randomize : List Word -> Random.Generator (List Int)
randomize wordsRemaining =
    Random.map2
        (\x y -> List.append x y)
        randomQuestionIndex
        (randomAnswerIndeces wordsRemaining)


randomQuestionIndex : Random.Generator (List Int)
randomQuestionIndex =
    Random.list 1 (Random.int 0 3)


randomAnswerIndeces : List Word -> Random.Generator (List Int)
randomAnswerIndeces wordsRemaining =
    Random.list 4 (Random.int 0 (List.length wordsRemaining - 1))



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
