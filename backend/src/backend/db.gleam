import backend/context
import backend/log
import gleam/dynamic/decode
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import middle/album
import middle/album_artist
import middle/album_song
import middle/album_tag
import middle/artist
import middle/song
import middle/song_artist
import middle/song_tag
import middle/tag
import pog

pub fn query_error_format(error: pog.QueryError) -> String {
  case error {
    pog.ConnectionUnavailable -> "connection unavailable"
    pog.ConstraintViolated(message:, constraint:, detail:) ->
      "constraint [" <> constraint <> "] " <> message <> ": " <> detail
    pog.PostgresqlError(code:, name:, message:) ->
      "[" <> code <> "] " <> name <> ": " <> message
    pog.QueryTimeout -> "query timeout"
    pog.UnexpectedArgumentCount(expected:, got:) ->
      "unexpected argument count: got: "
      <> int.to_string(got)
      <> ", expected: "
      <> int.to_string(expected)
    pog.UnexpectedArgumentType(expected:, got:) ->
      "unexpected argument type got: " <> got <> ", expected: " <> expected
    pog.UnexpectedResultType(errors) -> {
      errors
      |> list.map(fn(error) {
        "{expected: " <> error.expected <> ", got: " <> error.found <> "}"
      })
      |> string.join(", ")
      |> string.append("decode error: ", _)
    }
  }
  |> string.append("DB ERROR: ", _)
}

pub fn transaction_error_format(error: pog.TransactionError(a)) -> String {
  case error {
    pog.TransactionQueryError(error) ->
      error
      |> query_error_format
      |> string.append("TRANSACTION ", _)
    pog.TransactionRolledBack(_) -> "TRANSACTION: rolled back"
  }
}

pub fn execute(query: pog.Query(a), ctx: context.Context) -> Result(Nil, Nil) {
  fetch(query, ctx)
  |> result.replace(Nil)
}

pub fn fetch(query: pog.Query(a), ctx: context.Context) -> Result(List(a), Nil) {
  query
  |> pog.execute(ctx.db)
  |> log.on_errorf(ctx, query_error_format)
  |> result.replace_error(Nil)
  |> result.map(fn(rows) { rows.rows })
}

pub fn fetch_one(query: pog.Query(a), ctx: context.Context) -> Result(a, Nil) {
  let result = fetch(query, ctx)
  case result {
    Error(_) -> Error(Nil)
    Ok([]) -> {
      log.error(ctx, "DB ERROR: expected one row got none")
      Error(Nil)
    }
    Ok([a]) -> Ok(a)
    Ok(_) -> {
      log.error(ctx, "DB ERROR: expected one row got many")
      Error(Nil)
    }
  }
}

pub fn song_insert(
  ctx: context.Context,
  song: song.Song,
) -> Result(song.Song, Nil) {
  "INSERT INTO song (name, file_name) VALUES($1, $2) RETURNING id;"
  |> pog.query()
  |> pog.parameter(song.name |> pog.text)
  |> pog.parameter(song.file_name |> pog.text)
  |> pog.returning(decode.field(0, song.id_decoder(), decode.success))
  |> fetch_one(ctx)
  |> result.map(fn(id) { song.Song(..song, id:) })
}

pub fn song_get_all(ctx: context.Context) -> Result(List(song.Song), Nil) {
  "SELECT id, name, file_name FROM song"
  |> pog.query()
  |> pog.returning({
    use id <- decode.field(0, song.id_decoder())
    use name <- decode.field(1, decode.string)
    use file_name <- decode.field(2, decode.string)
    song.Song(id:, name:, file_name:)
    |> decode.success()
  })
  |> fetch(ctx)
}

pub fn song_delete(ctx: context.Context, id: song.Id) -> Result(Nil, Nil) {
  "DELETE FROM song WHERE id = $1;"
  |> pog.query()
  |> pog.parameter(id.inner |> pog.int)
  |> execute(ctx)
}

pub fn song_update(ctx: context.Context, song: song.Song) -> Result(Nil, Nil) {
  "UPDATE song SET name = $2, file_name = $3 WHERE id = $1"
  |> pog.query()
  |> pog.parameter(song.id.inner |> pog.int)
  |> pog.parameter(song.name |> pog.text)
  |> pog.parameter(song.file_name |> pog.text)
  |> execute(ctx)
}

pub fn tag_insert(ctx: context.Context, tag: tag.Tag) -> Result(tag.Tag, Nil) {
  "INSERT INTO tag (name) VALUES($1) RETURNING id"
  |> pog.query()
  |> pog.parameter(tag.name |> pog.text)
  |> pog.returning(decode.field(0, tag.id_decoder(), decode.success))
  |> fetch_one(ctx)
  |> result.map(fn(id) { tag.Tag(..tag, id:) })
}

pub fn tag_get_all(ctx: context.Context) -> Result(List(tag.Tag), Nil) {
  "SELECT id, name FROM tag;"
  |> pog.query()
  |> pog.returning({
    use id <- decode.field(0, tag.id_decoder())
    use name <- decode.field(1, decode.string)
    tag.Tag(id:, name:) |> decode.success
  })
  |> fetch(ctx)
}

pub fn tag_delete(ctx: context.Context, id: tag.Id) -> Result(Nil, Nil) {
  "DELETE FROM tag WHERE id = ?;"
  |> pog.query()
  |> pog.parameter(id.inner |> pog.int)
  |> execute(ctx)
}

pub fn tag_update(ctx: context.Context, tag: tag.Tag) {
  "UPDATE tag SET name = $2 WHERE id = $1"
  |> pog.query()
  |> pog.parameter(tag.id.inner |> pog.int)
  |> pog.parameter(tag.name |> pog.text)
  |> execute(ctx)
}

pub fn artist_insert(
  ctx: context.Context,
  artist: artist.Artist,
) -> Result(artist.Artist, Nil) {
  "INSERT INTO artist (name) VALUES($1) RETURNING id"
  |> pog.query()
  |> pog.parameter(artist.name |> pog.text)
  |> pog.returning(decode.field(0, artist.id_decoder(), decode.success))
  |> fetch_one(ctx)
  |> result.map(fn(id) { artist.Artist(..artist, id:) })
}

pub fn artist_get_all(ctx: context.Context) -> Result(List(artist.Artist), Nil) {
  "SELECT id, name FROM artist;"
  |> pog.query()
  |> pog.returning({
    use id <- decode.field(0, artist.id_decoder())
    use name <- decode.field(1, decode.string)
    artist.Artist(id:, name:) |> decode.success
  })
  |> fetch(ctx)
}

pub fn artist_delete(ctx: context.Context, id: artist.Id) -> Result(Nil, Nil) {
  "DELETE FROM artist WHERE id = ?;"
  |> pog.query()
  |> pog.parameter(id.inner |> pog.int)
  |> execute(ctx)
}

pub fn artist_update(
  ctx: context.Context,
  artist: artist.Artist,
) -> Result(Nil, Nil) {
  "UPDATE artist SET name = $2 WHERE id = $1"
  |> pog.query()
  |> pog.parameter(artist.id.inner |> pog.int)
  |> pog.parameter(artist.name |> pog.text)
  |> execute(ctx)
}

pub fn album_insert(
  ctx: context.Context,
  album: album.Album,
) -> Result(album.Album, Nil) {
  "INSERT INTO album (name) VALUES($1) RETURNING id"
  |> pog.query()
  |> pog.parameter(album.name |> pog.text)
  |> pog.returning(decode.field(0, album.id_decoder(), decode.success))
  |> fetch_one(ctx)
  |> result.map(fn(id) { album.Album(..album, id:) })
}

pub fn album_get_all(ctx: context.Context) -> Result(List(album.Album), Nil) {
  "SELECT id, name FROM album;"
  |> pog.query()
  |> pog.returning({
    use id <- decode.field(0, album.id_decoder())
    use name <- decode.field(1, decode.string)
    album.Album(id:, name:) |> decode.success()
  })
  |> fetch(ctx)
}

pub fn album_delete(ctx: context.Context, id: album.Id) -> Result(Nil, Nil) {
  "DELETE FROM artist WHERE id = ?;"
  |> pog.query()
  |> pog.parameter(id.inner |> pog.int)
  |> execute(ctx)
}

pub fn album_update(
  ctx: context.Context,
  album: album.Album,
) -> Result(Nil, Nil) {
  "UPDATE album SET name = $2 WHERE id = $1"
  |> pog.query()
  |> pog.parameter(album.id.inner |> pog.int)
  |> pog.parameter(album.name |> pog.text)
  |> execute(ctx)
}

pub fn song_tag_get_all(
  ctx: context.Context,
) -> Result(List(song_tag.SongTag), Nil) {
  "SELECT song_id, tag_id FROM song_tag;"
  |> pog.query()
  |> pog.returning({
    use song_id <- decode.field(0, song.id_decoder())
    use tag_id <- decode.field(0, tag.id_decoder())
    song_tag.SongTag(song_id:, tag_id:) |> decode.success
  })
  |> fetch(ctx)
}

pub fn song_tag_delete(
  ctx: context.Context,
  song_tag: song_tag.SongTag,
) -> Result(Nil, Nil) {
  "DELETE FROM song_tag WHERE song_id = $1 AND tag_id = $2;"
  |> pog.query()
  |> pog.parameter(song_tag.song_id.inner |> pog.int)
  |> pog.parameter(song_tag.tag_id.inner |> pog.int)
  |> execute(ctx)
}

pub fn song_tag_upsert(
  ctx: context.Context,
  song_tag: song_tag.SongTag,
) -> Result(Nil, Nil) {
  "INSERT INTO song_tag (song_id, tag_id) VALUES ($1, $2) ON CONFLICT(song_id, tag_id) DO NOTHING;"
  |> pog.query()
  |> pog.parameter(song_tag.song_id.inner |> pog.int)
  |> pog.parameter(song_tag.tag_id.inner |> pog.int)
  |> execute(ctx)
}

pub fn album_song_get_all(ctx: context.Context) {
  "SELECT album_id, song_id, ordering FROM album_song;"
  |> pog.query()
  |> pog.returning({
    use album_id <- decode.field(0, album.id_decoder())
    use song_id <- decode.field(1, song.id_decoder())
    use ordering <- decode.field(2, decode.int)
    album_song.AlbumSong(album_id:, song_id:, ordering:) |> decode.success
  })
  |> fetch(ctx)
}

pub fn album_song_delete(ctx: context.Context, album_song: album_song.AlbumSong) {
  "DELETE FROM album_song WHERE album_id = $1 AND song_id = $2"
  |> pog.query()
  |> pog.parameter(album_song.album_id.inner |> pog.int)
  |> pog.parameter(album_song.song_id.inner |> pog.int)
  |> execute(ctx)
}

pub fn album_song_upsert(
  ctx: context.Context,
  album_song: album_song.AlbumSong,
) -> Result(Nil, Nil) {
  "INSERT INTO album_song (album_id, song_id, ordering) VALUES ($1, $2, $3) ON CONFLICT (album_id, song_id) DO UPDATE SET ordering = $3;"
  |> pog.query()
  |> pog.parameter(album_song.album_id.inner |> pog.int)
  |> pog.parameter(album_song.song_id.inner |> pog.int)
  |> pog.parameter(album_song.ordering |> pog.int)
  |> execute(ctx)
}

pub fn album_tag_get_all(
  ctx: context.Context,
) -> Result(List(album_tag.AlbumTag), Nil) {
  "SELECT album_id, tag_id FROM album_tag;"
  |> pog.query()
  |> pog.returning({
    use album_id <- decode.field(0, album.id_decoder())
    use tag_id <- decode.field(1, tag.id_decoder())
    album_tag.AlbumTag(album_id:, tag_id:) |> decode.success
  })
  |> fetch(ctx)
}

pub fn album_tag_delete(ctx: context.Context, album_tag: album_tag.AlbumTag) {
  "DELETE FROM album_tag WHERE album_id = $1 AND tag_id = $2;"
  |> pog.query()
  |> pog.parameter(album_tag.album_id.inner |> pog.int)
  |> pog.parameter(album_tag.tag_id.inner |> pog.int)
  |> execute(ctx)
}

pub fn album_tag_upsert(ctx: context.Context, album_tag: album_tag.AlbumTag) {
  "INSERT INTO album_tag (album_id, tag_id) VALUES($1, $2) ON CONFLICT(album_id, tag_id) DO NOTHING;"
  |> pog.query()
  |> pog.parameter(album_tag.album_id.inner |> pog.int)
  |> pog.parameter(album_tag.tag_id.inner |> pog.int)
  |> execute(ctx)
}

pub fn song_artist_get_all(ctx: context.Context) {
  "SELECT song_id, artist_id FROM song_artist;"
  |> pog.query()
  |> pog.returning({
    use song_id <- decode.field(0, song.id_decoder())
    use artist_id <- decode.field(1, artist.id_decoder())
    song_artist.SongArtist(song_id:, artist_id:) |> decode.success()
  })
  |> fetch(ctx)
}

pub fn song_artist_delete(
  ctx: context.Context,
  song_artist: song_artist.SongArtist,
) {
  "DELETE FROM song_artist WHERE song_id = $1 AND artist_id = $2"
  |> pog.query()
  |> pog.parameter(song_artist.song_id.inner |> pog.int)
  |> pog.parameter(song_artist.artist_id.inner |> pog.int)
  |> execute(ctx)
}

pub fn song_artist_upsert(
  ctx: context.Context,
  song_artist: song_artist.SongArtist,
) {
  "INSERT INTO song_artist (song_id, artist_id) VALUES ($1, $2) ON CONFLICT (song_id, artist_id) DO NOTHING;"
  |> pog.query()
  |> pog.parameter(song_artist.song_id.inner |> pog.int)
  |> pog.parameter(song_artist.artist_id.inner |> pog.int)
  |> execute(ctx)
}

pub fn album_artist_get_all(
  ctx: context.Context,
) -> Result(List(album_artist.AlbumArtist), Nil) {
  "SELECT album_id, artist_id FROM album_artist;"
  |> pog.query()
  |> pog.returning({
    use album_id <- decode.field(0, album.id_decoder())
    use artist_id <- decode.field(1, artist.id_decoder())
    album_artist.AlbumArtist(album_id:, artist_id:) |> decode.success
  })
  |> fetch(ctx)
}

pub fn album_artist_delete(
  ctx: context.Context,
  album_artist: album_artist.AlbumArtist,
) {
  "DELETE FROM album_artist WHERE album_id = $1 AND artist_id = $2"
  |> pog.query()
  |> pog.parameter(album_artist.album_id.inner |> pog.int)
  |> pog.parameter(album_artist.artist_id.inner |> pog.int)
  |> execute(ctx)
}

pub fn album_artist_upsert(
  ctx: context.Context,
  album_artist: album_artist.AlbumArtist,
) {
  "INSERT INTO album_artist (album_id, artist_id) VALUES ($1, $2) ON CONFLICT (album_id, artist_id) DO NOTHING;"
  |> pog.query()
  |> pog.parameter(album_artist.album_id.inner |> pog.int)
  |> pog.parameter(album_artist.artist_id.inner |> pog.int)
  |> execute(ctx)
}
