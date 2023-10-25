defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.WorkingTimes
  alias TimeManager.WorkingTimes.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"user_id" => user_id, "start" => start!, "end" => end!}) do
    workingtimes = WorkingTimes.list_workingtimes(user_id, start!, end!)
    render(conn, :index, workingtimes: workingtimes)
  end

  def create(conn, %{"user_id" => user_id, "working_time" => working_time}) do
    working_time_params = %{
      user_id: user_id,
      start: working_time["start"],
      end: working_time["end"]
    }

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{working_time}")
      |> render(:show, working_time: working_time)
    end
  end

  def show(conn, %{"user_id" => user_id_str, "id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)
    user_id = String.to_integer(user_id_str)

    if working_time.user_id == user_id do
      render(conn, :show, working_time: working_time)
    else
      send_resp(conn, :not_found, "")
    end
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkingTimes.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
