defmodule TimeManager.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "working_times" do
    field :start, TimeManager.StringDateTime
    field :end, TimeManager.StringDateTime
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end])
    |> validate_required([:start, :end])
  end
end
