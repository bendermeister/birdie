import gleam/dynamic/decode
import gleam/json
import middle/artist
import middle/tag

pub type Id {
  Id(inner: Int)
}

pub type Song {
  Song(id: Id, name: String, tags: List(tag.Id), artists: List(artist.Id))
}

pub fn id_decoder() -> decode.Decoder(Id) {
  use id <- decode.then(decode.int)
  id |> Id |> decode.success
}

pub fn json_decoder() -> decode.Decoder(Song) {
  use id <- decode.field("id", id_decoder())
  use name <- decode.field("name", decode.string)
  use tags <- decode.field("tags", decode.list(tag.id_decoder()))
  use artists <- decode.field("artists", decode.list(artist.id_decoder()))
  Song(id:, name:, tags:, artists:) |> decode.success
}

pub fn id_to_json(id: Id) -> json.Json {
  id.inner |> json.int
}

pub fn to_json(song: Song) {
  [
    #("id", song.id |> id_to_json()),
    #("name", song.name |> json.string()),
    #("tags", song.tags |> json.array(tag.id_to_json)),
    #("artists", song.artists |> json.array(artist.id_to_json)),
  ]
  |> json.object()
}
