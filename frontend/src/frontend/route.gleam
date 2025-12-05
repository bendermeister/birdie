import gleam/int
import gleam/result
import gleam/uri
import middle/album
import middle/artist
import middle/song
import middle/tag

pub type Route {
  Home
  Music
  MusicEdit(song_id: song.Id)
  MusicNew
  Album
  AlbumEdit(album_id: album.Id)
  Artist
  ArtistEdit(artist_id: artist.Id)
  Tag
  TagEdit(tag_id: tag.Id)
  Queue
  NotFound
}

pub fn to_uri(route: Route) {
  route
  |> to_string
  |> uri.parse()
  |> result.unwrap(uri.empty)
}

pub fn to_string(route: Route) -> String {
  case route {
    Album -> "/album"
    AlbumEdit(album_id:) -> "/album/edit/" <> int.to_string(album_id.inner)
    Artist -> "/artist"
    ArtistEdit(artist_id:) -> "/artist/edit/" <> int.to_string(artist_id.inner)
    Home -> "/"
    Music -> "/song"
    MusicEdit(song_id:) -> "/song/edit/" <> int.to_string(song_id.inner)
    Queue -> "/queue"
    Tag -> "/tag"
    TagEdit(tag_id:) -> "/tag/edit/" <> int.to_string(tag_id.inner)
    NotFound -> "/not_found"
    MusicNew -> "/song/new"
  }
}

pub fn from_uri(uri: uri.Uri) -> Route {
  case uri.path_segments(uri.path) {
    ["album"] -> Album |> Ok
    ["album", "edit", id] ->
      id |> int.parse() |> result.map(album.Id) |> result.map(AlbumEdit)
    ["artist"] -> Artist |> Ok
    ["artist", "edit", id] ->
      id |> int.parse() |> result.map(artist.Id) |> result.map(ArtistEdit)
    [] -> Home |> Ok
    [""] -> Home |> Ok
    ["song"] -> Music |> Ok
    ["song", "edit", id] ->
      id |> int.parse() |> result.map(song.Id) |> result.map(MusicEdit)
    ["song", "new"] -> MusicNew |> Ok
    ["queue"] -> Queue |> Ok
    ["tag"] -> Tag |> Ok
    ["tag", "edit", id] ->
      id |> int.parse() |> result.map(tag.Id) |> result.map(TagEdit)
    _ -> Error(Nil)
  }
  |> result.unwrap(NotFound)
}
