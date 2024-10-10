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
alias PhoenixApp.CollectionRequest

# Define seed data
collectionRequests = [
  %CollectionRequest{
    ref_url: "https://petsdeli.de/1",
    slug: "example-slug-1",
    segments: ["segment1", "segment2"],
    audiences: ["audience1", "audience2"],
    pet_type: "dog"
  },
  %CollectionRequest{
    ref_url: "https://petsdeli.de/2",
    slug: "example-slug-2",
    segments: ["segment3", "segment4"],
    audiences: ["audience3", "audience4"],
    pet_type: "cat"
  }
]

# Insert seed data into the database
Enum.each(collectionRequests, fn collectionRequest ->
  Repo.insert!(collectionRequest)
end)
