defmodule OpenPantry.Repo do
  use Ecto.Repo, otp_app: :open_pantry
  use Scrivener, page_size: 10

  import Ecto.Query, only: [from: 2]

  alias OpenPantry.User

  def filter_facility(query, conn) do
    user = Guardian.Plug.current_resource(conn)
    case user do
      %User{role: :superadmin} ->
        query
      %User{role: :admin, facility_id: facility_id} when facility_id > 0 ->
        from q in query, where: q.facility_id == ^facility_id
      _ ->
        from q in query, where: is_nil(q.facility_id)
    end
  end
end
