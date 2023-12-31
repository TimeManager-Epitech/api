defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Users
  alias TimeManager.Users.User

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"user_id" => user_id}) do
    user = Users.get_user!(user_id)
    render(conn, :show, user: user)
  end

  def show(conn, _params) do
      email = Map.get(conn.query_params, "email")
      username = Map.get(conn.query_params, "username")
      user = Users.get_user!(email, username)
      render(conn, :show, user: user)
  end

  def update(conn, %{"user_id" => user_id, "user" => user_params}) do
    user = Users.get_user!(user_id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"user_id" => user_id}) do
    user = Users.get_user!(user_id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
