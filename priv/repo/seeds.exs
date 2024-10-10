# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixApp.Repo.insert!(%PhoenixApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PhoenixApp.Repo
alias PhoenixApp.Collections.Log

logs = for _ <- 1..20 do
  %Log{
    ref_url: "http://petsdeli.de/#{:rand.uniform(1000)}",
    slug: "slug-#{:rand.uniform(1000)}",
    segments: ["segment1", "segment2"],
    audiences: ["audience1", "audience2"],
    pet_type: Enum.random(["dog", "cat",])
  }
end

Enum.each(logs, fn log ->
  Repo.insert!(log)
end)
