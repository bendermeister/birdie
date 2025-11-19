import gleam/dynamic/decode
import gleam/json
import gleam/result
import youid/uuid

pub type Id {
  Id(inner: uuid.Uuid)
}

pub type Artist {
  Artist(id: Id, name: String)
}

pub fn id_decoder() {
  use id <- decode.then(decode.string)
  id
  |> uuid.from_string()
  |> result.map(Id)
  |> result.map(decode.success)
  |> result.unwrap(decode.failure(Id(uuid.v4()), "Id"))
}

pub fn json_decoder() {
  use id <- decode.field("id", id_decoder())
  use name <- decode.field("name", decode.string)
  Artist(id:, name:) |> decode.success
}

pub fn id_to_json(id: Id) {
  id.inner |> uuid.to_string() |> json.string()
}

pub fn to_json(artist: Artist) {
  [
    #("id", artist.id |> id_to_json),
    #("name", artist.name |> json.string),
  ]
  |> json.object
}
