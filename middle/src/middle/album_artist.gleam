import gleam/dynamic/decode
import gleam/json
import middle/album
import middle/artist

pub type AlbumArtist {
  AlbumArtist(album_id: album.Id, artist_id: artist.Id)
}

pub fn to_json(x: AlbumArtist) {
  [
    #("album_id", x.album_id |> album.id_to_json()),
    #("artist_id", x.artist_id |> artist.id_to_json()),
  ]
  |> json.object()
}

pub fn json_decoder() {
  use album_id <- decode.field("album_id", album.id_decoder())
  use artist_id <- decode.field("artist_id", artist.id_decoder())
  AlbumArtist(album_id:, artist_id:) |> decode.success
}
