import gleam/json
import middle/album
import middle/album_song
import middle/song
import youid/uuid

pub fn to_from_json_test() {
  let x =
    album_song.AlbumSong(
      album_id: album.Id(uuid.v4()),
      song_id: song.Id(uuid.v4()),
      ordering: 1,
    )

  let assert Ok(out) =
    x
    |> album_song.to_json()
    |> json.to_string()
    |> json.parse(album_song.json_decoder())
  assert out == x
}
