defmodule Tasktracka.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Tasktracka.Repo

  alias Tasktracka.Accounts.User
  alias Tasktracka.Accounts.Manage

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User |> order_by(:id))
    |> Repo.preload(:role)
  end

  def list_team_by_manager_id(manager_id) do
    query = from m in Manage, where: m.manager_id == ^manager_id,
      join: u in User, on: m.managee_id==u.id,
      select: u
    Repo.all(query)
  end

  def list_users_managers(user_id) do
    query = from m in Manage, where: m.managee_id == ^user_id,
      join: u in User, on: m.manager_id==u.id,
      select: u
    Repo.all(query)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user(id), do: Repo.get(User, id) |> Repo.preload(:role)
  def get_user!(id), do: Repo.get!(User, id) |> Repo.preload(:role)

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_userid_by_name(name) do
    Repo.get_by(User, name: name)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def make_manager(attrs \\ %{}) do
    %Manage{}
    |> Manage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    IO.puts("USER = #{inspect(user)}")
    IO.puts("\nATTRS = #{inspect(attrs)}")
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def list_manages do
    Repo.all(Manage |> order_by(:manager_id))
  end

  def list_managees_by_manager_id(manager_id) do
    Repo.all(from m in Manage, where: m.manager_id == ^manager_id)
    |> Repo.preload(:managee)
  end

  def delete_manager_rels(user_id) do
    (from m in Manage,
      where: m.manager_id == ^user_id)
    |> Repo.delete_all()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
