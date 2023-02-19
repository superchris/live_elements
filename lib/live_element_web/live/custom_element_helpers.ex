defmodule LiveElementWeb.CustomElementHelpers do
  import Phoenix.Component
  alias Phoenix.HTML.Tag
  alias Phoenix.HTML

  ce_manifest_path = "#{__DIR__}/../../../assets/custom-elements.json"
  %{"modules" => modules} = File.read!(ce_manifest_path) |> Jason.decode!()
  for custom_element <- LiveElements.Helpers.find_custom_elements(modules) do
    %{"tagName" => tag_name, "events" => events} = custom_element
    function_name = tag_name |> String.replace("-", "_") |> String.to_atom()
    def unquote(function_name)(var!(assigns)) do
      custom_element_tag(assigns, unquote(custom_element |> Macro.escape()))
      # events = unquote(events |> Macro.escape())
      # tag_name = unquote(tag_name)
      # attrs = assigns_to_attributes(assigns) |> serialize()
      # event_names = events |> Enum.map(& &1["name"]) |> Enum.join(",")
      # assigns = assigns |> assign(tag_name: tag_name, attrs: attrs, events: event_names)
      # ~H"""
      # <.dynamic_tag name={@tag_name} {@attrs} phx-hook="PhoenixCustomEventHook" phx-send-events={@events}></.dynamic_tag>
      # """
    end
  end

  def custom_element_tag(assigns, %{"tagName" => tag_name, "events" => events}) do
    attrs = assigns_to_attributes(assigns) |> serialize()
    event_names = events |> Enum.map(& &1["name"]) |> Enum.join(",")
    assigns = assigns |> assign(tag_name: tag_name, attrs: attrs, events: event_names)
    ~H"""
    <.dynamic_tag name={@tag_name} {@attrs} phx-hook="PhoenixCustomEventHook" phx-send-events={@events}></.dynamic_tag>
    """
  end

  def serialize(assigns) do
    assigns |> Enum.map(fn {key, value} -> {key, Jason.encode!(value)} end)
  end
end
