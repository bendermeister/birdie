import backend/context
import backend/db
import backend/log
import gleam/bool
import gleam/dynamic/decode
import gleam/int
import gleam/list
import gleam/result
import pog

pub fn migrate(db: pog.Connection) -> Result(Nil, Nil) {
  let ctx = context.Context(id: "MIGRATION", db:)
  let level = get_level(ctx)
  use level <- result.try(level)

  pog.transaction(db, fn(db) {
    let ctx = context.Context(id: "MIGRATION TRANSACTION", db:)
    let result =
      migrations
      |> list.drop(level)
      |> list.index_fold(Ok(Nil), fn(acc, migration, index) {
        acc
        |> result.try(fn(_) {
          let index = int.to_string(index + level)
          log.info(ctx, "running migration: " <> index)
          migration(ctx)
          |> log.on_error(ctx, "error while running migration: " <> index)
        })
      })
    use _ <- result.try(result)

    "UPDATE migration SET level = $1;"
    |> pog.query()
    |> pog.parameter(migrations |> list.length() |> pog.int())
    |> db.execute(ctx)
  })
  |> log.on_errorf(ctx, db.transaction_error_format)
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
]

pub fn get_level(ctx: context.Context) -> Result(Int, Nil) {
  // check if migration table even exists

  let exists =
    "SELECT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'migration');"
    |> pog.query()
    |> pog.returning(decode.field(0, decode.bool, decode.success))
    |> db.fetch_one(ctx)
  use exists <- result.try(exists)

  use <- bool.guard(when: !exists, return: Ok(0))

  "SELECT level FROM migration LIMIT 1;"
  |> pog.query()
  |> pog.returning(decode.field(0, decode.int, decode.success))
  |> db.fetch_one(ctx)
}

fn migration_0000(ctx: context.Context) -> Result(Nil, Nil) {
  let result =
    "
    CREATE TABLE migration (
      level BIGINT NOT NULL
    );
    "
    |> pog.query()
    |> db.execute(ctx)
  use _ <- result.try(result)

  let result =
    "INSERT INTO migration (level) VALUES(1);"
    |> pog.query()
    |> db.execute(ctx)
  use _ <- result.try(result)

  Ok(Nil)
}

fn migration_0001(ctx: context.Context) -> Result(Nil, Nil) {
  "
  CREATE TABLE artist (
    id      BIGINT  NOT NULL UNIQUE,
    name    TEXT    NOT NULL,

    PRIMARY KEY(id)
  );
  "
  |> pog.query()
  |> db.execute(ctx)
}

fn migration_0002(ctx: context.Context) -> Result(Nil, Nil) {
  "
  CREATE TABLE tag (
    id      BIGINT  NOT NULL UNIQUE,
    name    TEXT    NOT NULL,

    PRIMARY KEY(id)
  );
  "
  |> pog.query()
  |> db.execute(ctx)
}

fn migration_0003(ctx: context.Context) -> Result(Nil, Nil) {
  "
  CREATE TABLE song (
    id          BIGINT  NOT NULL UNIQUE,
    name        TEXT    NOT NULL,
    file_name   TEXT    NOT NULL,

    PRIMARY KEY(id)
  );
  "
  |> pog.query()
  |> db.execute(ctx)
}

fn migration_0004(ctx: context.Context) -> Result(Nil, Nil) {
  "
  CREATE TABLE album (
    id      BIGINT NOT NULL UNIQUE,
    name    TEXT NOT NULL,

    PRIMARY KEY(id)
  );
  "
  |> pog.query()
  |> db.execute(ctx)
}

fn migration_0005(ctx: context.Context) -> Result(Nil, Nil) {
  "
  CREATE TABLE song_tag (
    song_id     BIGINT REFERENCES song(id) ON DELETE CASCADE,
    tag_id      BIGINT REFERENCES tag(id) ON DELETE CASCADE,
    PRIMARY KEY (song_id, tag_id)
  );
  "
  |> pog.query()
  |> db.execute(ctx)
}

fn migration_0006(ctx: context.Context) -> Result(Nil, Nil) {
  "
  CREATE TABLE album_song (
    album_id BIGINT REFERENCES album(id) ON DELETE CASCADE,
    song_id  BIGINT REFERENCES song(id)  ON DELETE CASCADE,
    ordering BIGINT NOT NULL,
    PRIMARY KEY (album_id, song_id)
  );
  "
  |> pog.query()
  |> db.execute(ctx)
}

fn migration_0007(ctx: context.Context) -> Result(Nil, Nil) {
  "
  CREATE TABLE album_tag (
    album_id    BIGINT REFERENCES album(id) ON DELETE CASCADE,
    tag_id      BIGINT REFERENCES tag(id) ON DELETE CASCADE,

    PRIMARY KEY(album_id, tag_id)
  );
  "
  |> pog.query()
  |> db.execute(ctx)
}

fn migration_0008(ctx: context.Context) -> Result(Nil, Nil) {
  "
  CREATE TABLE song_artist (
    song_id     BIGINT REFERENCES song(id) ON DELETE CASCADE,
    artist_id   BIGINT REFERENCES artist(id) ON DELETE CASCADE,

    PRIMARY KEY (song_id, artist_id)
  )
  "
  |> pog.query()
  |> db.execute(ctx)
}

fn migration_0009(ctx: context.Context) -> Result(Nil, Nil) {
  "
  CREATE TABLE album_artist (
    album_id BIGINT REFERENCES album(id) ON DELETE CASCADE,
    artist_id BIGINT REFERENCES artist(id) ON DELETE CASCADE,

    PRIMARY KEY (album_id, artist_id)
  );
  "
  |> pog.query()
  |> db.execute(ctx)
}
