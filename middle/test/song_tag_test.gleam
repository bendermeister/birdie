import gleam/json
import middle/song
import middle/song_tag
import middle/tag
import youid/uuid

pub fn to_from_json_test() {
  let x =
    song_tag.SongTag(song_id: song.Id(uuid.v4()), tag_id: tag.Id(uuid.v4()))
  let assert Ok(out) =
    x
    |> song_tag.to_json()
    |> json.to_string()
    |> json.parse(song_tag.json_decoder())
  assert out == x
}
