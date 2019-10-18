module Views exposing (view)

import Helpers exposing (..)
import Html exposing (Html, button, div, h1, hr, input, label, option, p, span, table, tbody, td, text, th, thead, tr)
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
    in
    div []
        [ div
            [ class "d-flex justify-content-between mb-3" ]
            [ h1 [ class "text-warning" ] [ text "Bohdilang" ]
            , h1 [ class ("border pl-2 pr-2 text-" ++ scoreClass) ] [ text (String.fromInt model.score) ]
            ]
        , p [ class "mt-2" ]
            [ span [] [ text "You " ]
            , span [ class "text-success" ] [ text "get a point" ]
            , span [] [ text " every time you enter a Bohdi word correctly." ]
            ]
        , p []
            [ span [] [ text "Using the cheat button will show you the list words... but you will " ]
            , span [ class "text-danger" ] [ text "lose 2 points." ]
            ]
        , p [ class "d-flex mt-2" ]
            [ viewInput model.input
            , viewOutput model.output
            ]
        , div [ class "d-flex justify-content-between" ]
            [ button
                [ class "mt-2 btn btn-secondary"
                , onClick Restart
                ]
                [ text "Restart" ]
            , div [ class "mt-2" ] [ button [ class "btn btn-danger", onClick ToggleWords ] [ text "Cheat!" ] ]
            ]
        ]


viewInput : String -> Html Msg
viewInput val =
    input [ type_ "search", class "mr-3 form-control", style "max-width" "200px", placeholder "Bodi word...", value val, onInput Translate ] []


viewOutput : String -> Html Msg
viewOutput val =
    let
        validClass =
            if val == "" then
                ""

            else
                " border-success bg-success text-white"
    in
    input [ class ("form-control" ++ validClass), style "max-width" "200px", placeholder "Result...", disabled True, value val ] []



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
