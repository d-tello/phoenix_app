defmodule PhoenixApp.Repo.Migrations.CreateCollectionRequests do
  use Ecto.Migration

  def change do
    create table(:collection_requests) do
      add :ref_url, :string
      add :slug, :string
      add :segments, {:array, :string}
      add :audiences, {:array, :string}
      add :pet_type, :string

      timestamps(type: :utc_datetime)
    end
  end
end
