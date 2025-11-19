import gleam/json
import middle/song
import youid/uuid

pub fn to_from_json_test() {
  let song =
    song.Song(song.Id(uuid.v4()), "This is a Song", file_name: "asdfsadf.opus")
  let assert Ok(out) =
    song
    |> song.to_json
    |> json.to_string
    |> json.parse(song.json_decoder())

  assert out == song
}
