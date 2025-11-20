import gleam/json
import middle/artist
import middle/song
import middle/song_artist

pub fn to_from_json_test() {
  let x = song_artist.SongArtist(song_id: song.Id(1), artist_id: artist.Id(2))
  let assert Ok(out) =
    x
    |> song_artist.to_json()
    |> json.to_string()
    |> json.parse(song_artist.json_decoder())
  assert out == x
}
