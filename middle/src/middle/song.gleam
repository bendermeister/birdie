import gleam/dynamic/decode
import gleam/json

pub type Id {
  Id(inner: Int)
}

pub type Song {
  Song(id: Id, name: String, file_name: String)
}

pub fn id_decoder() -> decode.Decoder(Id) {
  use id <- decode.then(decode.int)
  id |> Id |> decode.success
}

pub fn json_decoder() -> decode.Decoder(Song) {
  use id <- decode.field("id", id_decoder())
  use name <- decode.field("name", decode.string)
  use file_name <- decode.field("file_name", decode.string)
  Song(id:, name:, file_name:) |> decode.success
}

pub fn id_to_json(id: Id) -> json.Json {
  id.inner |> json.int()
}

pub fn to_json(song: Song) {
  [
    #("id", song.id |> id_to_json()),
    #("name", song.name |> json.string()),
    #("file_name", song.file_name |> json.string),
  ]
  |> json.object()
}
