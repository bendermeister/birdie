import gleam/dynamic/decode
import gleam/json
import middle/album
import middle/song

pub type AlbumSong {
  AlbumSong(album_id: album.Id, song_id: song.Id, ordering: Int)
}

pub fn to_json(x: AlbumSong) {
  [
    #("album_id", x.album_id |> album.id_to_json()),
    #("song_id", x.song_id |> song.id_to_json()),
    #("ordering", x.ordering |> json.int),
  ]
  |> json.object()
}

pub fn json_decoder() {
  use album_id <- decode.field("album_id", album.id_decoder())
  use song_id <- decode.field("song_id", song.id_decoder())
  use ordering <- decode.field("ordering", decode.int)
  AlbumSong(album_id:, song_id:, ordering:)
  |> decode.success
}
