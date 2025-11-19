import gleam/dynamic/decode
import gleam/json
import gleam/result
import middle/artist
import middle/tag
import youid/uuid

pub type Id {
  Id(inner: uuid.Uuid)
}

pub type Song {
  Song(
    id: Id,
    name: String,
    tags: List(tag.Id),
    artists: List(artist.Id),
    file_name: String,
  )
}

pub fn id_decoder() -> decode.Decoder(Id) {
  use id <- decode.then(decode.string)
  id
  |> uuid.from_string()
  |> result.map(Id)
  |> result.map(decode.success)
  |> result.unwrap(decode.failure(Id(uuid.v4()), "Id"))
}

pub fn json_decoder() -> decode.Decoder(Song) {
  use id <- decode.field("id", id_decoder())
  use name <- decode.field("name", decode.string)
  use tags <- decode.field("tags", decode.list(tag.id_decoder()))
  use artists <- decode.field("artists", decode.list(artist.id_decoder()))
  use file_name <- decode.field("file_name", decode.string)
  Song(id:, name:, tags:, artists:, file_name:) |> decode.success
}

pub fn id_to_json(id: Id) -> json.Json {
  id.inner |> uuid.to_string() |> json.string()
}

pub fn to_json(song: Song) {
  [
    #("id", song.id |> id_to_json()),
    #("name", song.name |> json.string()),
    #("tags", song.tags |> json.array(tag.id_to_json)),
    #("artists", song.artists |> json.array(artist.id_to_json)),
    #("file_name", song.file_name |> json.string),
  ]
  |> json.object()
}
