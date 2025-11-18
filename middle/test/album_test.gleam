import gleam/json
import middle/album
import middle/artist
import middle/song
import middle/tag

pub fn to_from_json_test() {
  let album =
    album.Album(
      id: album.Id(1),
      name: "the album",
      artists: [artist.Id(1), artist.Id(2)],
      songs: [song.Id(1), song.Id(2)],
      tags: [tag.Id(69), tag.Id(2)],
    )

  let assert Ok(out) =
    album
    |> album.to_json
    |> json.to_string
    |> json.parse(album.json_decoder())

  assert out == album
}
