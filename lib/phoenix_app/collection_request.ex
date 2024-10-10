defmodule PhoenixApp.CollectionRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "collection_requests" do
    field :ref_url, :string
    field :slug, :string
    field :segments, {:array, :string}
    field :audiences, {:array, :string}
    field :pet_type, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(collection_request, attrs) do
    collection_request
    |> cast(attrs, [:ref_url, :slug, :segments, :audiences, :pet_type])
    |> validate_required([:ref_url, :slug, :segments, :audiences, :pet_type])
  end
end
