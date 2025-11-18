import gleam/dynamic/decode
import gleam/json
import middle/artist
import middle/song
import middle/tag

pub type Id {
  Id(inner: Int)
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
  use id <- decode.then(decode.int)
  id |> Id |> decode.success
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
  id.inner |> json.int
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
