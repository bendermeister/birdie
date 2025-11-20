import gleam/json
import middle/album
import middle/album_song
import middle/song

pub fn to_from_json_test() {
  let x =
    album_song.AlbumSong(
      album_id: album.Id(1),
      song_id: song.Id(2),
      ordering: 1,
    )

  let assert Ok(out) =
    x
    |> album_song.to_json()
    |> json.to_string()
    |> json.parse(album_song.json_decoder())
  assert out == x
}
