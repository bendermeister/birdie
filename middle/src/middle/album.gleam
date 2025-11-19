import gleam/dynamic/decode
import gleam/json
import gleam/result
import middle/artist
import middle/song
import middle/tag
import youid/uuid

pub type Id {
  Id(inner: uuid.Uuid)
}

pub type Album {
  Album(
    id: Id,
    name: String,
    artists: List(artist.Id),
    songs: List(song.Id),
    tags: List(tag.Id),
  )
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
  use artists <- decode.field("artists", decode.list(artist.id_decoder()))
  use songs <- decode.field("songs", decode.list(song.id_decoder()))
  use tags <- decode.field("tags", decode.list(tag.id_decoder()))
  Album(id:, name:, artists:, songs:, tags:)
  |> decode.success
}

pub fn id_to_json(id: Id) {
  id.inner |> uuid.to_string() |> json.string()
}

pub fn to_json(album: Album) {
  [
    #("id", album.id |> id_to_json()),
    #("name", album.name |> json.string()),
    #("artists", album.artists |> json.array(artist.id_to_json)),
    #("songs", album.songs |> json.array(song.id_to_json)),
    #("tags", album.tags |> json.array(tag.id_to_json)),
  ]
  |> json.object()
}
