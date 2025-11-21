import frontend/player
import frontend/route
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/pair
import gleam/result
import gleam/string
import middle/album
import middle/album_artist
import middle/album_song
import middle/album_tag
import middle/artist
import middle/query
import middle/song
import middle/song_artist
import middle/song_tag
import middle/tag

pub type Content {
  Song(song.Id)
  Album(album.Id)
}

pub type Player {
  Player(song: song.Song, duration: Int, played: Int, status: PlayerStatus)
}

pub type PlayerStatus {
  Pause
  Play
}

pub type Model {
  Model(
    route: route.Route,
    player: option.Option(player.Player),
    content: List(Content),
    query: query.Query,
    song: dict.Dict(song.Id, song.Song),
    tag: dict.Dict(tag.Id, tag.Tag),
    album: dict.Dict(album.Id, album.Album),
    artist: dict.Dict(artist.Id, artist.Artist),
    song_tag: dict.Dict(song.Id, List(song_tag.SongTag)),
    album_song: dict.Dict(album.Id, List(album_song.AlbumSong)),
    album_tag: dict.Dict(album.Id, List(album_tag.AlbumTag)),
    song_artist: dict.Dict(song.Id, List(song_artist.SongArtist)),
    album_artist: dict.Dict(album.Id, List(album_artist.AlbumArtist)),
  )
}

pub fn content_sort(model: Model) -> List(Content) {
  let tags = model.tag |> dict.to_list |> list.map(pair.second)
  let artists = model.artist |> dict.to_list |> list.map(pair.second)

  let matching_tags =
    model.query.query
    |> list.filter_map(fn(x) {
      case x {
        query.Artist(_) -> Error(Nil)
        query.Tag(x) -> Ok(x)
        query.Title(_) -> Error(Nil)
      }
    })
    |> list.flat_map(fn(query) {
      tags
      |> list.filter(fn(tag) { string.contains(tag.name, query) })
      |> list.map(fn(x) { x.id })
    })

  let matching_artists =
    model.query.query
    |> list.filter_map(fn(x) {
      case x {
        query.Artist(x) -> Ok(x)
        query.Tag(_) -> Error(Nil)
        query.Title(_) -> Error(Nil)
      }
    })
    |> list.flat_map(fn(query) {
      artists
      |> list.filter(fn(x) { string.contains(x.name, query) })
      |> list.map(fn(x) { x.id })
    })

  let matching_titles =
    model.query.query
    |> list.filter_map(fn(x) {
      case x {
        query.Artist(_) -> Error(Nil)
        query.Tag(_) -> Error(Nil)
        query.Title(x) -> Ok(x)
      }
    })

  model.content
  |> list.filter_map(fn(x) {
    let #(title, artist, tag) = case x {
      Album(id) -> {
        let title = dict.get(model.album, id) |> result.map(fn(x) { x.name })
        let artist =
          dict.get(model.album_artist, id)
          |> result.map(list.map(_, fn(x) { x.artist_id }))
        let tag =
          dict.get(model.album_tag, id)
          |> result.map(list.map(_, fn(x) { x.tag_id }))

        #(title, artist, tag)
      }
      Song(id) -> {
        let title = dict.get(model.song, id) |> result.map(fn(x) { x.name })
        let artist =
          dict.get(model.song_artist, id)
          |> result.map(list.map(_, fn(x) { x.artist_id }))
        let tag =
          dict.get(model.song_tag, id)
          |> result.map(list.map(_, fn(x) { x.tag_id }))

        #(title, artist, tag)
      }
    }
    use title <- result.try(title)
    use artist <- result.try(artist)
    use tag <- result.try(tag)

    let tag_count =
      tag
      |> list.count(fn(tag) { matching_tags |> list.contains(tag) })

    let artist_count =
      artist
      |> list.count(fn(artist) { matching_artists |> list.contains(artist) })

    let title_count =
      matching_titles |> list.count(fn(m) { string.contains(title, m) })

    let ordering = tag_count + artist_count + title_count

    #(ordering, x)
    |> Ok
  })
  |> list.sort(fn(a, b) { int.compare(a.0, b.0) })
  |> list.map(pair.second)
}
