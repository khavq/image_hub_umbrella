# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ImageHub.Repo.insert!(%ImageHub.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
for name <- ~w( Apple Facebook Microsoft ) do
  ImageHub.Multimedia.create_category(name)
end
