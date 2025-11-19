import gleam/bool
import gleam/dynamic/decode
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import pog

pub fn migrate(db: pog.Connection) -> Result(Nil, Nil) {
  let level =
    get_level(db)
    |> on_error("could not get migration level")
  use level <- result.try(level)

  pog.transaction(db, fn(db) {
    let result =
      migrations
      |> list.drop(level)
      |> list.index_fold(Ok(Nil), fn(acc, migration, index) {
        acc
        |> result.try(fn(_) {
          let index = int.to_string(index + level)
          io.println("MIGRATION INFO: running migration: " <> index)
          migration(db)
          |> on_error("error while running migration: " <> index)
        })
      })
    use _ <- result.try(result)

    io.println("MIGRATION INFO: updating migration level")

    "UPDATE migration SET level = $1;"
    |> pog.query()
    |> pog.parameter(migrations |> list.length() |> pog.int())
    |> pog.execute(db)
    |> on_query_error()
  })
  |> on_error("error while running migrations changes are reverted")
  |> result.replace(Nil)
  |> result.replace_error(Nil)
}

const migrations = [
  migration_0000,
  migration_0001,
  migration_0002,
  migration_0003,
  migration_0004,
  migration_0005,
  migration_0006,
  migration_0007,
  migration_0008,
  migration_0009,
  migration_0010,
  migration_0011,
]

fn format_pog_error(err: pog.QueryError) -> String {
  case err {
    pog.ConnectionUnavailable -> "connection unavailable"
    pog.ConstraintViolated(message:, constraint:, detail:) ->
      "constraint violated: message: {"
      <> message
      <> "}, constraint: {"
      <> constraint
      <> "}, detail: {"
      <> detail
      <> "}"
    pog.PostgresqlError(code:, name:, message:) ->
      "postgresql error: code: {"
      <> code
      <> "}, name: {"
      <> name
      <> "}, message: {"
      <> message
      <> "}"
    pog.QueryTimeout -> "query timeout"
    pog.UnexpectedArgumentCount(expected:, got:) ->
      "unexpected argument count: expected: "
      <> int.to_string(expected)
      <> ", got: "
      <> int.to_string(got)
    pog.UnexpectedArgumentType(expected:, got:) ->
      "unexpected argument type: expected: " <> expected <> " got: " <> got
    pog.UnexpectedResultType(_) -> "unexpected result type -> decoding error"
  }
}

fn on_query_error(result: Result(a, pog.QueryError)) -> Result(a, Nil) {
  result
  |> result.map_error(fn(err) {
    let message = err |> format_pog_error()
    io.println_error("MIGRATION ERROR: " <> message)
  })
}

fn on_error(result: Result(a, b), message) -> Result(a, b) {
  case result {
    Error(_) -> io.println_error("MIGRATION ERROR: " <> message)
    Ok(_) -> Nil
  }
  result
}

pub fn get_level(db: pog.Connection) -> Result(Int, Nil) {
  // check if migration table even exists

  let decoder = {
    use exists <- decode.field(0, decode.bool)
    exists |> decode.success
  }

  let exists =
    "SELECT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'migration');"
    |> pog.query()
    |> pog.returning(decoder)
    |> pog.execute(db)
    |> on_query_error()
  use exists <- result.try(exists)

  let exists =
    exists.rows
    |> list.first()
    |> on_error("migration table exists query returnend no rows")
  use exists <- result.try(exists)

  use <- bool.guard(when: !exists, return: Ok(0))

  let decoder = {
    use level <- decode.field(0, decode.int)
    level |> decode.success
  }

  let level =
    "SELECT level FROM migration LIMIT 1;"
    |> pog.query()
    |> pog.returning(decoder)
    |> pog.execute(db)
    |> on_query_error()
  use level <- result.try(level)
  level.rows
  |> list.first()
  |> on_error("migration level query returnend no rows")
}

fn migration_0000(db: pog.Connection) -> Result(Nil, Nil) {
  let result =
    "
    CREATE TABLE migration (
      level BIGINT NOT NULL
    );
    "
    |> pog.query()
    |> pog.execute(db)
    |> on_query_error()
  use _ <- result.try(result)

  let result =
    "INSERT INTO migration (level) VALUES(1);"
    |> pog.query()
    |> pog.execute(db)
    |> on_query_error()
  use _ <- result.try(result)

  Ok(Nil)
}

fn migration_0001(db: pog.Connection) -> Result(Nil, Nil) {
  "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";"
  |> pog.query()
  |> pog.execute(db)
  |> on_query_error()
  |> result.replace(Nil)
}

fn migration_0002(db: pog.Connection) -> Result(Nil, Nil) {
  "
  CREATE TABLE artist (
    id      UUID NOT NULL UNIQUE,
    name    TEXT NOT NULL,

    PRIMARY KEY(id)
  );
  "
  |> pog.query()
  |> pog.execute(db)
  |> on_query_error()
  |> result.replace(Nil)
}

fn migration_0003(db: pog.Connection) -> Result(Nil, Nil) {
  "
  CREATE TABLE tag (
    id      UUID NOT NULL UNIQUE,
    name    TEXT NOT NULL,

    PRIMARY KEY(id)
  );
  "
  |> pog.query()
  |> pog.execute(db)
  |> on_query_error()
  |> result.replace(Nil)
}

fn migration_0004(db: pog.Connection) -> Result(Nil, Nil) {
  "
  CREATE TABLE song (
    id          UUID NOT NULL UNIQUE,
    name        TEXT NOT NULL,
    file_name   TEXT NOT NULL,

    PRIMARY KEY(id)
  );
  "
  |> pog.query()
  |> pog.execute(db)
  |> on_query_error()
  |> result.replace(Nil)
}

fn migration_0005(db: pog.Connection) -> Result(Nil, Nil) {
  "
  CREATE TABLE album (
    id      UUID NOT NULL UNIQUE,
    name    TEXT NOT NULL,

    PRIMARY KEY(id)
  );
  "
  |> pog.query()
  |> pog.execute(db)
  |> on_query_error()
  |> result.replace(Nil)
}

fn migration_0006(db: pog.Connection) -> Result(Nil, Nil) {
  "
  CREATE TABLE song_tag (
    song_id     UUID REFERENCES song(id) ON DELETE CASCADE,
    tag_id      UUID REFERENCES tag(id) ON DELETE CASCADE,
    PRIMARY KEY (song_id, tag_id)
  );
  "
  |> pog.query()
  |> pog.execute(db)
  |> on_query_error()
  |> result.replace(Nil)
}

fn migration_0007(db: pog.Connection) -> Result(Nil, Nil) {
  "
  CREATE TABLE album_song (
    album_id UUID REFERENCES album(id) ON DELETE CASCADE,
    song_id UUID REFERENCES song(id) ON DELETE CASCADE,
    PRIMARY KEY (album_id, song_id)
  );
  "
  |> pog.query()
  |> pog.execute(db)
  |> on_query_error()
  |> result.replace(Nil)
}

fn migration_0008(db: pog.Connection) -> Result(Nil, Nil) {
  "
  CREATE TABLE album_tag (
    album_id UUID REFERENCES album(id) ON DELETE CASCADE,
    tag_id UUID REFERENCES tag(id) ON DELETE CASCADE,

    PRIMARY KEY(album_id, tag_id)
  );
  "
  |> pog.query()
  |> pog.execute(db)
  |> on_query_error()
  |> result.replace(Nil)
}

fn migration_0009(db: pog.Connection) -> Result(Nil, Nil) {
  "
  CREATE TABLE song_artist (
    song_id UUID REFERENCES song(id) ON DELETE CASCADE,
    artist_id UUID REFERENCES artist(id) ON DELETE CASCADE,

    PRIMARY KEY(song_id, artist_id)
  );
  "
  |> pog.query()
  |> pog.execute(db)
  |> on_query_error()
  |> result.replace(Nil)
}

fn migration_0010(db: pog.Connection) -> Result(Nil, Nil) {
  "
  CREATE TABLE album_artist (
    album_id UUID REFERENCES album(id) ON DELETE CASCADE,
    artist_id UUID REFERENCES artist(id) ON DELETE CASCADE,

    PRIMARY KEY (album_id, artist_id)
  );
  "
  |> pog.query()
  |> pog.execute(db)
  |> on_query_error()
  |> result.replace(Nil)
}

fn migration_0011(db: pog.Connection) -> Result(Nil, Nil) {
  "ALTER TABLE album_song ADD COLUMN ordering INTEGER NOT NULL"
  |> pog.query()
  |> pog.execute(db)
  |> on_query_error()
  |> result.replace(Nil)
}
