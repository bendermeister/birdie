import middle/album
import middle/album_artist
import middle/album_song
import middle/album_tag
import middle/song
import middle/song_artist
import middle/song_tag
import middle/tag

pub type Message {
  MessageInfo(String)
  MessageError(String)

  ClientReceivedSong(List(song.Song))
  ClientRecievedTag(List(tag.Tag))
  ClientReceivedAlbum(List(album.Album))
  ClientReceivedSongTag(List(song_tag.SongTag))
  ClientReceivedSongArtist(List(song_artist.SongArtist))
  ClientReceivedAlbumTag(List(album_tag.AlbumTag))
  ClientReceivedAlbumSong(List(album_song.AlbumSong))
  ClientReceivedAlbumArtist(List(album_artist.AlbumArtist))
}
