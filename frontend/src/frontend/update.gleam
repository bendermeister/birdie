import frontend/message
import frontend/model
import frontend/player
import frontend/route
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/pair
import lustre
import lustre/effect
import modem
import plinth/javascript/global as js

pub fn update(
  model: model.Model,
  message: message.Message,
) -> #(model.Model, effect.Effect(message.Message)) {
  case message {
    message.MessageError(msg) -> {
      io.println_error(msg)
      #(model, effect.none())
    }
    message.MessageInfo(msg) -> {
      io.println(msg)
      #(model, effect.none())
    }
    message.ClientReceivedAlbum(album) -> {
      album
      |> list.map(fn(a) { #(a.id, a) })
      |> dict.from_list()
      |> dict.merge(model.album, _)
      |> fn(x) { model.Model(..model, album: x) }
      |> pair.new(effect.none())
    }
    message.ClientReceivedAlbumArtist(album_artist) -> {
      album_artist
      |> list.group(fn(a) { a.album_id })
      |> dict.merge(model.album_artist, _)
      |> fn(x) { model.Model(..model, album_artist: x) }
      |> pair.new(effect.none())
    }
    message.ClientReceivedAlbumSong(album_song) -> {
      album_song
      |> list.group(fn(a) { a.album_id })
      |> dict.map_values(fn(_, songs) {
        songs |> list.sort(fn(a, b) { int.compare(a.ordering, b.ordering) })
      })
      |> fn(x) { model.Model(..model, album_song: x) }
      |> pair.new(effect.none())
    }
    message.ClientReceivedAlbumTag(album_tag) -> {
      album_tag
      |> list.group(fn(t) { t.album_id })
      |> dict.merge(model.album_tag, _)
      |> fn(x) { model.Model(..model, album_tag: x) }
      |> pair.new(effect.none())
    }
    message.ClientReceivedSong(song) -> {
      song
      |> list.map(fn(s) { #(s.id, s) })
      |> dict.from_list()
      |> dict.merge(model.song, _)
      |> fn(x) { model.Model(..model, song: x) }
      |> pair.new(effect.none())
    }
    message.ClientReceivedSongArtist(song_artist) -> {
      song_artist
      |> list.group(fn(s) { s.song_id })
      |> dict.merge(model.song_artist, _)
      |> fn(x) { model.Model(..model, song_artist: x) }
      |> pair.new(effect.none())
    }
    message.ClientReceivedSongTag(song_tag) -> {
      song_tag
      |> list.group(fn(s) { s.song_id })
      |> dict.merge(model.song_tag, _)
      |> fn(x) { model.Model(..model, song_tag: x) }
      |> pair.new(effect.none())
    }
    message.ClientRecievedTag(tag) -> {
      tag
      |> list.map(fn(tag) { #(tag.id, tag) })
      |> dict.from_list()
      |> dict.merge(model.tag, _)
      |> fn(x) { model.Model(..model, tag: x) }
      |> pair.new(effect.none())
    }
    message.Tick -> {
      io.println("tick")

      let effect =
        effect.from(fn(dispatch) {
          let _ = js.set_timeout(1000, fn() { dispatch(message.Tick) })
          Nil
        })

      let player = model.player |> option.map(player.update)
      let model = model.Model(..model, player:)
      #(model, effect)
    }
    message.ClientLoadedRoute(route) -> {
      let model = model.Model(..model, route:)
      #(model, effect.none())
    }
    message.UserChangeRoute(route) -> {
      let effect =
        modem.push(route |> route.to_string(), option.None, option.None)
      #(model, effect)
    }
  }
}
