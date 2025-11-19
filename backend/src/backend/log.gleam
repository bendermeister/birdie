import backend/context
import birl
import gleam/io
import gleam/string
import youid/uuid

pub fn info(ctx: context.Context, message: String) -> Nil {
  format(ctx, "INFO", message)
}

pub fn error(ctx: context.Context, message: String) -> Nil {
  format(ctx, "ERROR", message)
}

pub fn warn(ctx: context.Context, message: String) -> Nil {
  format(ctx, "WARN", message)
}

pub fn on_ok(result: Result(a, b), ctx: context.Context, message: String) {
  case result {
    Error(_) -> Nil
    Ok(_) -> info(ctx, message)
  }
  result
}

pub fn on_error(
  result: Result(a, b),
  ctx: context.Context,
  message: String,
) -> Result(a, b) {
  case result {
    Error(_) -> error(ctx, message)
    Ok(_) -> Nil
  }
  result
}

pub fn on_errorf(
  result: Result(a, b),
  ctx: context.Context,
  format: fn(b) -> String,
) -> Result(a, b) {
  case result {
    Error(b) -> error(ctx, format(b))
    Ok(_) -> Nil
  }
  result
}

pub fn format(ctx: context.Context, level: String, message: String) -> Nil {
  let now = birl.now() |> birl.to_iso8601() |> string.trim()
  let id = ctx.id |> uuid.to_string() |> string.trim()
  let message = "[" <> level <> " " <> now <> " " <> id <> "]: " <> message
  io.println(message)
}
