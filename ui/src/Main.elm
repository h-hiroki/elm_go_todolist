import Browser
import Html exposing (Html, button, div, text, ul, li, input, p)
import Html.Attributes exposing (value, disabled)
import Html.Events exposing (onClick, onSubmit, onInput)
import Http


---- MAIN ----
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


---- MODEL ----
type alias Model =
    { input : String
    , todos : List String
    , healthCheckResult : String
    }

init : () -> (Model, Cmd Msg)
init _ =
    (
        { input = ""
        , todos = []
        , healthCheckResult = ""
        }
        , Cmd.none
    )


---- UPDATE ----
type Msg
    = Input String
    | Submit
    | DoHealthCheck
    | HealthCheck (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Input input ->
            -- 入力中の文字を更新する
            ( { model | input = input}
            , Cmd.none
            )

        Submit ->
            -- 入力中の文字をリセットしてtodoを追加する
            ({ model
                | input = ""
                , todos = model.input :: model.todos
            }
            , Cmd.none
            )

        DoHealthCheck ->
            -- back-end health check
            ( model
            , Http.get
                { url = "http://localhost:1323/health_check"
                , expect = Http.expectString HealthCheck
                }
            )

        HealthCheck (Ok result) ->
            ( { model | healthCheckResult = result }, Cmd.none )

        HealthCheck (Err error) ->
            ( { model | healthCheckResult = Debug.toString error }, Cmd.none )


---- SUBSCRIPTIONS ----
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


---- VIEW ----
view : Model -> Html Msg
view model =
    div []
        [ Html.form [ onSubmit Submit ]
            [ input [ value model.input, onInput Input ] []
            , button
                [ disabled (String.length model.input < 1) ]
                [ text "Submit"]
            ]
        , ul [] (List.map viewTodo model.todos)
        , div []
            [ button [ onClick DoHealthCheck ] [ text "testbutton"]
            , p [] [ text model.healthCheckResult ]
            ]
        ]

viewTodo : String -> Html Msg
viewTodo todo =
    li [] [ text todo]
