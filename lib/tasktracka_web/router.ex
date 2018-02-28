defmodule TasktrackaWeb.Router do
  use TasktrackaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :get_current_user
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug NavigationHistory.Tracker
  end

  def get_current_user(conn, _params) do
    # TODO: Move this module out of the router module
    user_id = get_session(conn, :user_id)
    user = Tasktracka.Accounts.get_user(user_id || -1)
    assign(conn, :current_user, user)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TasktrackaWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    

    resources "/users", UserController
    post "/users/add_managee", UserController, :add_managee
    resources "/tasks", TaskController
    resources "/roles", RoleController
    get "/profile", PageController, :profile

    get "/todo", PageController, :todo
    get "/manage_todo", PageController, :manage_todos
    post "/todo", PageController, :create_todo
    get "/todo/:id", PageController, :edit_todo
    post "/todo/delete/:id", PageController, :delete_todo
    put "/todo/update/:id", PageController, :update_todo

    post "/session", SessionController, :create
    delete "/session", SessionController, :delete

    resources "/admin", AdminController, only: [:index]
    get "/admin/update", AdminController, :make_manager
    get "/admin/remove_manager", AdminController, :remove_manager
    get "/admin/list_manages", AdminController, :list_manages

    resources "/timeblocks", TimeBlockController
  end

  # Other scopes may use custom stacks.
  scope "/api", TasktrackaWeb do
    pipe_through :api
    resources "/timeblocks", TimeBlockApiController, except: [:new, :edit]
    post "/timeblocks/startstop", TimeBlockApiController, :startstop
  end
end
