defmodule TimeManager.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/, message: "Invalid email provided")
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end
end
