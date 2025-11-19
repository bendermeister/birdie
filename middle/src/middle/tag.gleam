import gleam/dynamic/decode
import gleam/json
import gleam/result
import youid/uuid

pub type Id {
  Id(inner: uuid.Uuid)
}

pub type Tag {
  Tag(id: Id, name: String)
}

pub fn id_decoder() -> decode.Decoder(Id) {
  use id <- decode.then(decode.string)
  id
  |> uuid.from_string()
  |> result.map(Id)
  |> result.map(decode.success)
  |> result.unwrap(decode.failure(Id(uuid.v4()), "Id"))
}

pub fn json_decoder() -> decode.Decoder(Tag) {
  use id <- decode.field("id", id_decoder())
  use name <- decode.field("name", decode.string)
  Tag(id:, name:)
  |> decode.success
}

pub fn id_to_json(id: Id) {
  id.inner |> uuid.to_string |> json.string()
}

pub fn to_json(tag: Tag) {
  [#("id", tag.id |> id_to_json), #("name", tag.name |> json.string)]
  |> json.object()
}
