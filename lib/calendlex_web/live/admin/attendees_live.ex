defmodule CalendlexWeb.Admin.AttendeesLive do
  use CalendlexWeb, :admin_live_view

  alias CalendlexWeb.Admin.Components.Modal

  @impl LiveView
  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [attendees: []]}
  end

  @impl LiveView
  def handle_params(_, _, socket) do
    attendees = Calendlex.available_event_types()

    socket =
      socket
      |> assign(attendees: attendees)
      |> assign(attendees_count: length(attendees))
      |> assign(section: "attendees")
      |> assign(page_title: "Attendees")
      |> assign(delete_attendee: nil)

    {:noreply, socket}
  end

  @impl LiveView
  def handle_info({:confirm_delete, event_type}, socket) do
    {:noreply, assign(socket, delete_event_type: event_type)}
  end

  def handle_info(:clone_error, socket) do
    {:noreply, put_flash(socket, :error, "A similar event type already exists")}
  end

  @impl LiveView
  def handle_event("delete", _, socket) do
    event_type = socket.assigns.delete_event_type

    {:ok, _} = Calendlex.delete_event_type(event_type)

    socket =
      socket
      |> put_flash(:info, "Deleted")
      |> push_patch(to: Routes.live_path(socket, __MODULE__))

    {:noreply, socket}
  end

  def handle_event("modal_close", _, socket) do
    {:noreply, assign(socket, delete_event_type: nil)}
  end

  def nav_link_classes(is_current) do
    class_list([
      {"py-6 font-medium text-gray-400 border-b-2 border-white hover:border-gray-400 hover:text-gray-600",
       true},
      {"text-gray-600 border-blue-500 hover:text-gray-600 hover:border-blue-500", is_current}
    ])
  end
end
