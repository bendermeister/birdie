import gleam/dynamic/decode
import gleam/json

pub type Query {
  Query(query: List(Part))
}

pub type Part {
  Tag(String)
  Artist(String)
  Title(String)
}

pub fn part_to_json(part: Part) {
  let #(t, p) = case part {
    Tag(p) -> #("tag", p)
    Artist(p) -> #("artist", p)
    Title(p) -> #("title", p)
  }
  [
    #("type", t |> json.string),
    #("body", p |> json.string),
  ]
  |> json.object()
}

pub fn part_json_decoder() {
  use t <- decode.field("type", decode.string)
  use p <- decode.field("body", decode.string)
  case t {
    "tag" -> Tag(p) |> decode.success
    "artist" -> Artist(p) |> decode.success
    "title" -> Title(p) |> decode.success
    _ -> decode.failure(Title(p), "Part")
  }
}

pub fn to_json(query: Query) {
  [#("query", query.query |> json.array(part_to_json))]
  |> json.object()
}

pub fn json_decoder() {
  use query <- decode.field("query", decode.list(part_json_decoder()))
  query |> Query |> decode.success
}
