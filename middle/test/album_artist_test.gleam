import gleam/json
import middle/album
import middle/album_artist
import middle/artist

pub fn to_from_json_test() {
  let x =
    album_artist.AlbumArtist(album_id: album.Id(1), artist_id: artist.Id(2))
  let assert Ok(out) =
    x
    |> album_artist.to_json()
    |> json.to_string
    |> json.parse(album_artist.json_decoder())
  assert out == x
}
