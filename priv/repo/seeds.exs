# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Platform.Repo.insert!(%Platform.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias Platform.Repo
alias Platform.Permissions.Role

# Default system roles
roles = [
  %{
    name: "admin",
    description: "Full system administrator with complete access"
  },
  %{
    name: "supply_chain_manager",
    description: "Manages supply chain workflows and configurations"
  },
  %{
    name: "document_approver",
    description: "Can review and approve documents in workflows"
  },
  %{
    name: "viewer",
    description: "Read-only access to system data"
  },
  %{
    name: "supplier",
    description: "External supplier with limited document access"
  }
]

# Insert roles if they don't exist
Enum.each(roles, fn role_params ->
  case Repo.get_by(Role, name: role_params[:name]) do
    nil ->
      Platform.Permissions.create_role!(role_params)

    existing_role ->
      IO.puts("Role #{existing_role.name} already exists, skipping...")
  end
end)

IO.puts("Successfully seeded default roles!")
