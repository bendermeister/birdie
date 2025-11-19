import gleam/json
import middle/artist
import middle/song
import middle/tag
import youid/uuid

pub fn to_from_json_test() {
  let song =
    song.Song(
      song.Id(uuid.v4()),
      "This is a Song",
      tags: [tag.Id(uuid.v4()), tag.Id(uuid.v4())],
      artists: [artist.Id(uuid.v4()), artist.Id(uuid.v4())],
      file_name: "asdfsadf.opus",
    )
  let assert Ok(out) =
    song
    |> song.to_json
    |> json.to_string
    |> json.parse(song.json_decoder())

  assert out == song
}
