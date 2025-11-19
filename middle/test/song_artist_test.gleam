import gleam/json
import middle/artist
import middle/song
import middle/song_artist
import youid/uuid

pub fn to_from_json_test() {
  let x =
    song_artist.SongArtist(
      song_id: song.Id(uuid.v4()),
      artist_id: artist.Id(uuid.v4()),
    )
  let assert Ok(out) =
    x
    |> song_artist.to_json()
    |> json.to_string()
    |> json.parse(song_artist.json_decoder())
  assert out == x
}
