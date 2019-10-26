module Views exposing (view)

import Html exposing (Html, br, button, div, h1, h2, hr, input, label, option, p, span, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, disabled, href, id, max, min, placeholder, style, type_, value)
import Html.Events exposing (onBlur, onClick, onInput)
import Http
import Types exposing (..)
import Words exposing (words)


view : Model -> Html Msg
view model =
    div
        [ class "container-fluid"
        ]
        [ div
            [ class "row justify-content-center" ]
            [ div
                [ class "col border mt-sm-4 mb-sm-4 p-3", style "max-width" "360px" ]
                [ if model.showWords then
                    viewWords

                  else
                    viewTranslator model
                ]
            ]
        ]


viewTranslator : Model -> Html Msg
viewTranslator model =
    let
        scoreClass =
            if model.score > 0 then
                "success"

            else if model.score < 0 then
                "danger"

            else
                "secondary"

        titleClass =
            case model.correct of
                Just True ->
                    "success"

                Just False ->
                    "danger"

                Nothing ->
                    "warning"
    in
    div []
        [ div
            [ class "d-flex justify-content-between mb-3" ]
            [ h1 [ class ("text-" ++ titleClass) ] [ text "Bohdilang" ]
            , h1 [ class ("border pl-2 pr-2 text-" ++ scoreClass) ] [ text (String.fromInt model.score) ]
            ]
        , viewQuestionAndAnswers model
        , div [ class "mt-2 d-flex justify-content-between" ]
            [ button [ class "btn btn-danger", onClick ToggleWords ] [ text "Help!" ]
            , button [ class "btn btn-secondary", onClick Restart ] [ text "Restart" ]
            ]
        ]


viewQuestionAndAnswers : Model -> Html Msg
viewQuestionAndAnswers model =
    if model.finished then
        p [] [ text ("Thanks for playing! Your score is " ++ String.fromInt model.score ++ " out of a possible " ++ String.fromInt (List.length words - 4) ++ ".") ]

    else
        div []
            [ p [ class "mt-2" ]
                [ span [] [ text "You " ]
                , span [ class "text-success" ] [ text "get a point" ]
                , span [] [ text (" every time you guess the correct Bohdi word. " ++ String.fromInt (List.length model.wordsRemaining - 4) ++ " words left.") ]
                ]
            , p []
                [ viewQuestion model.question
                , viewAnswers model.answers
                ]
            , p []
                [ span [] [ text "Using the help button will show you the list words... but you will " ]
                , span [ class "text-danger" ] [ text "lose 2 points." ]
                ]
            ]


viewQuestion : Maybe Word -> Html Msg
viewQuestion question =
    div [ class "row mb-2" ]
        [ h1 [ class "m-3 p-2 text-center text-white bg-dark", style "width" "100%" ]
            [ text
                (case question of
                    Just word ->
                        Tuple.second word

                    Nothing ->
                        "Nothing"
                )
            ]
        ]


viewAnswers : List (Maybe Word) -> Html Msg
viewAnswers answers =
    let
        viewAnswer answer =
            div [ class "col-6 text-center mb-3" ]
                [ button [ class "btn btn-primary", style "width" "150px", onClick (Answer answer) ]
                    [ text
                        (case answer of
                            Just word ->
                                Tuple.first word

                            Nothing ->
                                "Nothing"
                        )
                    ]
                ]
    in
    div [ class "row" ]
        (List.map viewAnswer answers)



-- WORDS LIST


viewWords : Html Msg
viewWords =
    div []
        [ div [ class "text-right" ]
            [ button [ class "btn btn-sm btn-danger mb-2", onClick ToggleWords ] [ text "Close" ]
            ]
        , table
            [ class "table table-striped p-3" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Bohdilang" ]
                    , th [] [ text "English" ]
                    ]
                ]
            , tbody []
                (List.map viewWordRow words)
            ]
        ]


viewWordRow : Word -> Html Msg
viewWordRow word =
    tr []
        [ td [] [ text (Tuple.first word) ]
        , td [] [ text (Tuple.second word) ]
        ]
