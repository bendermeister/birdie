import gleam/dynamic/decode
import gleam/json
import middle/song
import middle/tag

pub type SongTag {
  SongTag(song_id: song.Id, tag_id: tag.Id)
}

pub fn to_json(x: SongTag) -> json.Json {
  [
    #("song_id", x.song_id |> song.id_to_json()),
    #("tag_id", x.tag_id |> tag.id_to_json()),
  ]
  |> json.object()
}

pub fn json_decoder() -> decode.Decoder(SongTag) {
  use song_id <- decode.field("song_id", song.id_decoder())
  use tag_id <- decode.field("tag_id", tag.id_decoder())
  SongTag(song_id:, tag_id:)
  |> decode.success
}
