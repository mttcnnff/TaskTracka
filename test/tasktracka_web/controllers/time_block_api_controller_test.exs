defmodule TasktrackaWeb.TimeBlockApiControllerTest do
  use TasktrackaWeb.ConnCase

  alias Tasktracka.Tracker
  alias Tasktracka.Tracker.TimeBlockApi

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:time_block_api) do
    {:ok, time_block_api} = Tracker.create_time_block_api(@create_attrs)
    time_block_api
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all timeblocks", %{conn: conn} do
      conn = get conn, time_block_api_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create time_block_api" do
    test "renders time_block_api when data is valid", %{conn: conn} do
      conn = post conn, time_block_api_path(conn, :create), time_block_api: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, time_block_api_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, time_block_api_path(conn, :create), time_block_api: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update time_block_api" do
    setup [:create_time_block_api]

    test "renders time_block_api when data is valid", %{conn: conn, time_block_api: %TimeBlockApi{id: id} = time_block_api} do
      conn = put conn, time_block_api_path(conn, :update, time_block_api), time_block_api: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, time_block_api_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, time_block_api: time_block_api} do
      conn = put conn, time_block_api_path(conn, :update, time_block_api), time_block_api: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete time_block_api" do
    setup [:create_time_block_api]

    test "deletes chosen time_block_api", %{conn: conn, time_block_api: time_block_api} do
      conn = delete conn, time_block_api_path(conn, :delete, time_block_api)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, time_block_api_path(conn, :show, time_block_api)
      end
    end
  end

  defp create_time_block_api(_) do
    time_block_api = fixture(:time_block_api)
    {:ok, time_block_api: time_block_api}
  end
end
