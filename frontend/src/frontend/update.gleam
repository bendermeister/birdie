import frontend/message
import frontend/model
import gleam/io
import gleam/list
import lustre/effect

pub fn update(
  model: model.Model,
  message: message.Message,
) -> #(model.Model, effect.Effect(message.Message)) {
  case message {
    message.ClientReceivedAlbum(album) -> {
      let albums = model.albums |> list.append(album)
      let model = model.Model(..model, albums:)
      #(model, effect.none())
    }
    message.ClientReceivedAlbumArtist(x) -> {
      let album_artists = model.album_artists |> list.append(x)
      let model = model.Model(..model, album_artists:)
      #(model, effect.none())
    }
    message.ClientReceivedAlbumSong(x) -> {
      let album_songs = model.album_songs |> list.append(x)
      let model = model.Model(..model, album_songs:)
      #(model, effect.none())
    }
    message.ClientReceivedAlbumTag(x) -> {
      let album_tags = model.album_tags |> list.append(x)
      let model = model.Model(..model, album_tags:)
      #(model, effect.none())
    }
    message.ClientReceivedSong(x) -> {
      let songs = model.songs |> list.append(x)
      let model = model.Model(..model, songs:)
      #(model, effect.none())
    }
    message.ClientReceivedSongArtist(x) -> {
      let song_artists = model.song_artists |> list.append(x)
      let model = model.Model(..model, song_artists:)
      #(model, effect.none())
    }
    message.ClientReceivedSongTag(x) -> {
      let song_tags = model.song_tags |> list.append(x)
      let model = model.Model(..model, song_tags:)
      #(model, effect.none())
    }
    message.ClientRecievedTag(x) -> {
      let tags = model.tags |> list.append(x)
      let model = model.Model(..model, tags:)
      #(model, effect.none())
    }
    message.MessageError(msg) -> {
      io.println_error(msg)
      #(model, effect.none())
    }
    message.MessageInfo(msg) -> {
      io.println(msg)
      #(model, effect.none())
    }
  }
}
