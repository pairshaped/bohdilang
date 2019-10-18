module Views exposing (view)

import Helpers exposing (..)
import Html exposing (Html, button, div, h1, hr, input, label, option, p, span, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, disabled, href, id, max, min, placeholder, style, type_, value)
import Html.Events exposing (onBlur, onClick, onInput)
import Html.Events.Extra exposing (onClickPreventDefault)
import Http
import RemoteData exposing (RemoteData(..))
import Types exposing (..)


view : Model -> Html Msg
view model =
    div
        [ class "bg-secondary container-fluid"
        ]
        [ div
            [ class "row justify-content-center" ]
            [ div
                [ class "col bg-white mt-sm-4 mb-sm-4 p-2", style "max-width" "360px" ]
                [ case model.data of
                    NotAsked ->
                        viewNotReady "Initializing..."

                    Loading ->
                        viewNotReady "Loading..."

                    Failure error ->
                        let
                            errorMessage =
                                case error of
                                    Http.BadUrl string ->
                                        "Bad URL: " ++ string

                                    Http.Timeout ->
                                        "Network timeout"

                                    Http.NetworkError ->
                                        "Network error"

                                    Http.BadStatus int ->
                                        "Bad status response from server"

                                    Http.BadBody string ->
                                        "Bad body response from server: " ++ string
                        in
                        viewFetchError errorMessage

                    Success data ->
                        if model.showWords then
                            viewWords data.words

                        else
                            viewTranslator model
                ]
            ]
        ]


viewNotReady : String -> Html Msg
viewNotReady message =
    p [ class "p-3" ] [ text message ]


viewFetchError : String -> Html Msg
viewFetchError message =
    div
        [ class "p-3" ]
        [ p [] [ text message ]
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
        [ h1 [ class "mb-3 text-warning" ] [ text "Bohdilang" ]
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
                , disabled (model.score == 0)
                , onClick Restart
                ]
                [ text "Restart" ]
            , div [ class "mt-2" ] [ button [ class "btn btn-danger", onClick ToggleWords ] [ text "Cheat!" ] ]
            ]
        , div [ class ("mt-2 display-2 text-center text-" ++ scoreClass) ] [ text (String.fromInt model.score) ]
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


viewWords : List Word -> Html Msg
viewWords words =
    div []
        [ div [ class "text-right" ]
            [ button [ class "btn btn-sm btn-danger mb-2", onClick ToggleWords ] [ text "Close" ]
            ]
        , table
            [ class "table table-striped p-3" ]
            [ thead []
                [ tr []
                    [ th [] [ text "English" ]
                    , th [] [ text "Bohdi" ]
                    ]
                ]
            , tbody []
                (List.map viewWordRow words)
            ]
        ]


viewWordRow : Word -> Html Msg
viewWordRow word =
    tr []
        [ td [] [ text word.en ]
        , td [] [ text word.bd ]
        ]
