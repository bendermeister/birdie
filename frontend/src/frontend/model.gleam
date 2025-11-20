import middle/album
import middle/album_artist
import middle/album_song
import middle/album_tag
import middle/artist
import middle/song
import middle/song_artist
import middle/song_tag
import middle/tag

pub type Model {
  Model(
    tags: List(tag.Tag),
    songs: List(song.Song),
    artists: List(artist.Artist),
    albums: List(album.Album),
    song_tags: List(song_tag.SongTag),
    song_artists: List(song_artist.SongArtist),
    album_tags: List(album_tag.AlbumTag),
    album_songs: List(album_song.AlbumSong),
    album_artists: List(album_artist.AlbumArtist),
  )
}
