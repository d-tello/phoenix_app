defmodule PhoenixApp.CollectionsTest do
  use PhoenixApp.DataCase

  alias PhoenixApp.Collections

  describe "collections_logs" do
    alias PhoenixApp.Collections.Log

    import PhoenixApp.CollectionsFixtures

    @invalid_attrs %{ref_url: nil, slug: nil, segments: nil, audiences: nil, pet_type: nil}

    test "list_collections_logs/0 returns all collections_logs" do
      log = log_fixture()
      assert Collections.list_collections_logs() == [log]
    end

    test "get_log!/1 returns the log with given id" do
      log = log_fixture()
      assert Collections.get_log!(log.id) == log
    end

    test "create_log/1 with valid data creates a log" do
      valid_attrs = %{ref_url: "some ref_url", slug: "some slug", segments: ["option1", "option2"], audiences: ["option1", "option2"], pet_type: "some pet_type"}

      assert {:ok, %Log{} = log} = Collections.create_log(valid_attrs)
      assert log.ref_url == "some ref_url"
      assert log.slug == "some slug"
      assert log.segments == ["option1", "option2"]
      assert log.audiences == ["option1", "option2"]
      assert log.pet_type == "some pet_type"
    end

    test "create_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Collections.create_log(@invalid_attrs)
    end

    test "update_log/2 with valid data updates the log" do
      log = log_fixture()
      update_attrs = %{ref_url: "some updated ref_url", slug: "some updated slug", segments: ["option1"], audiences: ["option1"], pet_type: "some updated pet_type"}

      assert {:ok, %Log{} = log} = Collections.update_log(log, update_attrs)
      assert log.ref_url == "some updated ref_url"
      assert log.slug == "some updated slug"
      assert log.segments == ["option1"]
      assert log.audiences == ["option1"]
      assert log.pet_type == "some updated pet_type"
    end

    test "update_log/2 with invalid data returns error changeset" do
      log = log_fixture()
      assert {:error, %Ecto.Changeset{}} = Collections.update_log(log, @invalid_attrs)
      assert log == Collections.get_log!(log.id)
    end

    test "delete_log/1 deletes the log" do
      log = log_fixture()
      assert {:ok, %Log{}} = Collections.delete_log(log)
      assert_raise Ecto.NoResultsError, fn -> Collections.get_log!(log.id) end
    end

    test "change_log/1 returns a log changeset" do
      log = log_fixture()
      assert %Ecto.Changeset{} = Collections.change_log(log)
    end
  end
end
