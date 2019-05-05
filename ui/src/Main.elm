import Browser
import Html exposing (Html, button, div, text, ul, li, input)
import Html.Attributes exposing (value, disabled)
import Html.Events exposing (onClick, onSubmit, onInput)

main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }

---- MODEL ----
type alias Model =
    { input : String
    , todos : List String
    }

init : Model
init =
    { input = ""
    , todos = []
    }

---- UPDATE ----
type Msg
    = Input String
    | Submit

update : Msg -> Model -> Model
update msg model =
    case msg of
        Input input ->
            -- 入力中の文字を更新する
            { model | input = input}
        
        Submit ->
            -- 入力中の文字をリセットしてtodoを追加する
            { model
                | input = ""
                , todos = model.input :: model.todos
            }

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
        ]

viewTodo : String -> Html Msg
viewTodo todo =
    li [] [ text todo]
