defmodule PhoenixApp.Collections.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "collections_logs" do
    field :ref_url, :string
    field :slug, :string
    field :segments, {:array, :string}
    field :audiences, {:array, :string}
    field :pet_type, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:ref_url, :slug, :segments, :audiences, :pet_type])
    |> validate_required([:ref_url, :slug, :segments, :audiences, :pet_type])
  end
end
