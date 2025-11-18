import gleam/dynamic/decode
import gleam/json

pub type Id {
  Id(inner: Int)
}

pub type Tag {
  Tag(id: Id, name: String)
}

pub fn id_decoder() -> decode.Decoder(Id) {
  use id <- decode.then(decode.int)
  id |> Id |> decode.success
}

pub fn json_decoder() -> decode.Decoder(Tag) {
  use id <- decode.field("id", id_decoder())
  use name <- decode.field("name", decode.string)
  Tag(id:, name:)
  |> decode.success
}

pub fn id_to_json(id: Id) {
  id.inner |> json.int
}

pub fn to_json(tag: Tag) {
  [#("id", tag.id |> id_to_json), #("name", tag.name |> json.string)]
  |> json.object()
}
