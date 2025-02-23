defmodule PhoenixApp.Collections do
  @moduledoc """
  The Collections context.
  """

  import Ecto.Query, warn: false
  alias PhoenixApp.Repo

  alias PhoenixApp.Collections.Log

  @doc """
  Returns the list of collections_logs.

  ## Examples

      iex> list_collections_logs()
      [%Log{}, ...]

  """
  def list_collections_logs do
    Repo.all(Log)
  end

  @doc """
  Gets a single log.

  Raises `Ecto.NoResultsError` if the Log does not exist.

  ## Examples

      iex> get_log!(123)
      %Log{}

      iex> get_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_log!(id), do: Repo.get!(Log, id)

  @doc """
  Creates a log.

  ## Examples

      iex> create_log(%{field: value})
      {:ok, %Log{}}

      iex> create_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_log(attrs \\ %{}) do
    %Log{}
    |> Log.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a log.

  ## Examples

      iex> update_log(log, %{field: new_value})
      {:ok, %Log{}}

      iex> update_log(log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_log(%Log{} = log, attrs) do
    log
    |> Log.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a log.

  ## Examples

      iex> delete_log(log)
      {:ok, %Log{}}

      iex> delete_log(log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_log(%Log{} = log) do
    Repo.delete(log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking log changes.

  ## Examples

      iex> change_log(log)
      %Ecto.Changeset{data: %Log{}}

  """
  def change_log(%Log{} = log, attrs \\ %{}) do
    Log.changeset(log, attrs)
  end

  @doc """
  Returns the logs statistics grouped by slug within a date range.
  """
def list_logs_stats(fromDate, toDate, rowsPerPage) do
  # Log the parameters
  IO.inspect(fromDate, label: "From Date")
  IO.inspect(toDate, label: "To Date")
  IO.inspect(rowsPerPage, label: "Rows Per Page")

  from(l in Log,
    where: l.inserted_at >= ^fromDate and l.inserted_at <= ^toDate,
    limit: ^rowsPerPage,
    select: %{
      id: l.id,
      slug: l.slug,
      ref_url: l.ref_url,
      segments: l.segments,
      audiences: l.audiences,
      pet_type: l.pet_type
    }
  )
  |> Repo.all()
end
end
