defmodule TimeManager.StringDateTime do
    use Ecto.Type

    def type, do: NaiveDateTime

    def cast(string) when is_binary(string) do
        case String.match?(string, ~r/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) (2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]$/) do
          true -> case NaiveDateTime.from_iso8601(string) do
            {:ok, dt} -> {:ok, dt}
            {:error, reason} -> {:error, reason}
          end
          false -> raise(ArgumentError, "Invalid DateTime format. Accepted formats are : yyyy-mm-dd HH:ii:ss")
        end
    end

    def cast(_), do: :error

    def load(date), do: {:ok, date}
    def load(_), do: :error

    def dump(date), do: {:ok, NaiveDateTime.to_string(date)}
    def dump(_), do: :error
end
