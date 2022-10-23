defmodule Calendlex.Attendee.Repo do
  import Ecto.Query, only: [where: 3, order_by: 3]

  alias Calendlex.{Attendee, Repo}

  def available do
    Attendee
    |> where([e], is_nil(e.deleted_at))
    |> order_by([e], e.name)
    |> Repo.all()
  end
end
