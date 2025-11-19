import gleam/int
import gleam/list
import gleam/string
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
