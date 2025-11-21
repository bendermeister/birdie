import frontend/player
import frontend/route
import gleam/dict
import gleam/option
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
