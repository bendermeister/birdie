import gleam/dynamic/decode
import gleam/json

pub type Id {
  Id(inner: Int)
}

pub type Artist {
  Artist(id: Id, name: String)
}

pub fn id_decoder() {
  use id <- decode.then(decode.int)
  id |> Id |> decode.success
}

pub fn json_decoder() {
  use id <- decode.field("id", id_decoder())
  use name <- decode.field("name", decode.string)
  Artist(id:, name:) |> decode.success
}

pub fn id_to_json(id: Id) {
  id.inner |> json.int
}

pub fn to_json(artist: Artist) {
  [
    #("id", artist.id |> id_to_json),
    #("name", artist.name |> json.string),
  ]
  |> json.object
}
