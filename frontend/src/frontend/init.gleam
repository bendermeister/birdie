import frontend/message
import frontend/model
import gleam/dynamic/decode
import gleam/io
import gleam/result
import lustre/effect
import middle/album
import middle/album_artist
import middle/album_song
import middle/album_tag
import middle/song
import middle/song_artist
import middle/song_tag
import middle/tag
import rsvp

pub fn init(_args) -> #(model.Model, effect.Effect(message.Message)) {
  io.println("Hello World")
  let effect_factory = fn(
    url,
    message: fn(a) -> message.Message,
    error_message,
    decoder: decode.Decoder(a),
  ) {
    let rsvp_handler =
      rsvp.expect_json(decoder, fn(result) {
        result
        |> result.map(message)
        |> result.unwrap(message.MessageError(error_message))
      })
    rsvp.get(url, rsvp_handler)
  }

  let effect =
    [
      effect_factory(
        "/api/tag/get/all",
        message.ClientRecievedTag,
        "tags could not be loaded",
        decode.list(tag.json_decoder()),
      ),

      effect_factory(
        "/api/song/get/all",
        message.ClientReceivedSong,
        "songs could not be loaded",
        decode.list(song.json_decoder()),
      ),

      effect_factory(
        "/api/album/get/all",
        message.ClientReceivedAlbum,
        "albums could not be loaded",
        decode.list(album.json_decoder()),
      ),

      effect_factory(
        "/api/song_tag/get/all",
        message.ClientReceivedSongTag,
        "song tags could not be loaded",
        decode.list(song_tag.json_decoder()),
      ),

      effect_factory(
        "/api/song_artist/get/all",
        message.ClientReceivedSongArtist,
        "song artits could not be loaded",
        decode.list(song_artist.json_decoder()),
      ),

      effect_factory(
        "/api/album_tag/get/all",
        message.ClientReceivedAlbumTag,
        "album tags could not be loaded",
        decode.list(album_tag.json_decoder()),
      ),

      effect_factory(
        "/api/album_song/get/all",
        message.ClientReceivedAlbumSong,
        "album songs could not be loaded",
        decode.list(album_song.json_decoder()),
      ),

      effect_factory(
        "/api/album_artist/get/all",
        message.ClientReceivedAlbumArtist,
        "album artists could not be loaded",
        decode.list(album_artist.json_decoder()),
      ),
    ]
    |> effect.batch()

  let model =
    model.Model(
      tags: [],
      songs: [],
      artists: [],
      albums: [],
      song_tags: [],
      song_artists: [],
      album_tags: [],
      album_songs: [],
      album_artists: [],
    )

  #(model, effect)
}
