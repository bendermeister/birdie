import gleam/dynamic/decode
import gleam/json
import middle/artist
import middle/song

pub type SongArtist {
  SongArtist(song_id: song.Id, artist_id: artist.Id)
}

pub fn to_json(x: SongArtist) {
  [
    #("song_id", x.song_id |> song.id_to_json()),
    #("artist_id", x.artist_id |> artist.id_to_json()),
  ]
  |> json.object()
}

pub fn json_decoder() {
  use song_id <- decode.field("song_id", song.id_decoder())
  use artist_id <- decode.field("artist_id", artist.id_decoder())
  SongArtist(song_id:, artist_id:)
  |> decode.success
}
