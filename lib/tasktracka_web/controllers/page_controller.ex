defmodule TasktrackaWeb.PageController do
  use TasktrackaWeb, :controller

  def index(conn, _params) do
  	if conn.assigns.current_user do
  		IO.puts("Render Home")
  	else
  		IO.puts("Render Log In")
  	end
    render(conn, "index.html")
  end
end
