import frontend/message
import frontend/model
import frontend/route
import gleam/dict
import gleam/dynamic/decode
import gleam/io
import gleam/option
import gleam/result
import lustre/effect
import middle/album
import middle/album_artist
import middle/album_song
import middle/album_tag
import middle/query
import middle/song
import middle/song_artist
import middle/song_tag
import middle/tag
import modem
import plinth/javascript/global as js
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
      effect.from(fn(dispatch) {
        let _ = js.set_timeout(1000, fn() { dispatch(message.Tick) })
        Nil
      }),

      modem.init(fn(uri) { uri |> route.from_uri |> message.ClientLoadedRoute }),
    ]
    |> effect.batch()

  let route =
    modem.initial_uri()
    |> result.map(route.from_uri)
    |> result.unwrap(route.Home)

  let model =
    model.Model(
      content: [],
      song: dict.new(),
      player: option.None,
      tag: dict.new(),
      album: dict.new(),
      artist: dict.new(),
      song_tag: dict.new(),
      album_song: dict.new(),
      album_tag: dict.new(),
      song_artist: dict.new(),
      album_artist: dict.new(),
      query: query.Query(query: []),
      route:,
    )

  #(model, effect)
}
