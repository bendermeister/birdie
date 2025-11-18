import gleam/json
import middle/artist
import middle/song
import middle/tag

pub fn to_from_json_test() {
  let song =
    song.Song(
      song.Id(1),
      "This is a Song",
      tags: [tag.Id(1), tag.Id(2)],
      artists: [artist.Id(2), artist.Id(4)],
    )
  let assert Ok(out) =
    song
    |> song.to_json
    |> json.to_string
    |> json.parse(song.json_decoder())

  assert out == song
}
