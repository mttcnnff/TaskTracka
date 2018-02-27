defmodule Tasktracka.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracka.Accounts.User

  alias Tasktracka.Accounts.Manage


  schema "users" do
    field :email, :string
    field :name, :string
    belongs_to :role, Tasktracka.RoleManager.Role

    has_many :manager_rels, Manage, foreign_key: :manager_id #rels where user is manager
    has_many :managee_rels, Manage, foreign_key: :managee_id #rels where user is managee
    has_many :managers, through: [:managee_rels, :manager]
    has_many :managees, through: [:manager_rels, :managee]


    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name, :role_id])
    |> foreign_key_constraint(:role_id)
    |> validate_required([:email, :name, :role_id])
  end
end
