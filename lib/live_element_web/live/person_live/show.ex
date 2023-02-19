defmodule LiveElementWeb.PersonLive.Show do
  use LiveElementWeb, :live_view

  alias LiveElement.People

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(todos: ["hey"])}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:person, People.get_person!(id))}
  end

  @impl true
  def handle_event("add_todo", %{"todo" => todo}, %{assigns: %{todos: todos}} = socket) do
    {:noreply, socket |> assign(todos: todos ++ [todo])}
  end

  import LiveElementWeb.CustomElementHelpers
  # def todo_list(assigns) do
  #   ~H"""
  #   <todo-list id="todo_list" todos={Jason.encode!(@todos)} phx-hook="PhoenixCustomEventHook" phx-send-events="add_todo"></todo-list>
  #   """
  # end

  defp page_title(:show), do: "Show Person"
  defp page_title(:edit), do: "Edit Person"
end
