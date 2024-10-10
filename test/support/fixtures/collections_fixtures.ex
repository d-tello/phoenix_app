defmodule PhoenixApp.CollectionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhoenixApp.Collections` context.
  """

  @doc """
  Generate a log.
  """
  def log_fixture(attrs \\ %{}) do
    {:ok, log} =
      attrs
      |> Enum.into(%{
        audiences: ["option1", "option2"],
        pet_type: "some pet_type",
        ref_url: "some ref_url",
        segments: ["option1", "option2"],
        slug: "some slug"
      })
      |> PhoenixApp.Collections.create_log()

    log
  end
end
