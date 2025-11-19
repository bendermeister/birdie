import gleam/json
import middle/album
import middle/artist
import middle/song
import middle/tag
import youid/uuid

pub fn to_from_json_test() {
  let album =
    album.Album(
      id: album.Id(uuid.v4()),
      name: "the album",
      artists: [artist.Id(uuid.v4()), artist.Id(uuid.v4())],
      songs: [song.Id(uuid.v4()), song.Id(uuid.v4())],
      tags: [tag.Id(uuid.v4()), tag.Id(uuid.v4())],
    )

  let assert Ok(out) =
    album
    |> album.to_json
    |> json.to_string
    |> json.parse(album.json_decoder())

  assert out == album
}
