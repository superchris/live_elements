defmodule LiveElements.Helpers do
  import Phoenix.Component
  alias LiveElements.Helpers

  defmacro __using__(_opts) do

    for custom_element <- Helpers.custom_elements() do
      %{"tagName" => tag_name, "events" => events} = custom_element
      function_name = function_name(tag_name)

      quote do
        def unquote(function_name)(assigns) do
          Helpers.custom_element_tag(
            assigns,
            unquote(tag_name),
            unquote(events |> Macro.escape())
          )
        end
      end
    end
  end

  def function_name(tag_name) do
    tag_name |> String.replace("-", "_") |> String.to_atom()
  end

  def custom_elements do
    ce_manifest_path = "#{__DIR__}/../assets/custom-elements.json"
    %{"modules" => modules} = File.read!(ce_manifest_path) |> Jason.decode!()
    modules |> LiveElements.Helpers.find_custom_elements()
  end

  def serialize(assigns) do
    assigns |> Enum.map(fn {key, value} -> {key, Jason.encode!(value)} end)
  end

  def find_custom_elements(modules) do
    modules
    |> Enum.map(& &1["declarations"])
    |> Enum.concat()
    |> Enum.filter(& &1["customElement"])
  end

  def custom_element_tag(assigns, tag_name, events) do
    attrs = assigns_to_attributes(assigns) |> serialize()
    event_names = events |> Enum.map(& &1["name"]) |> Enum.join(",")
    assigns = assigns |> assign(tag_name: tag_name, attrs: attrs, events: event_names)

    ~H"""
    <.dynamic_tag name={@tag_name} {@attrs} phx-hook="PhoenixCustomEventHook" phx-send-events={@events}></.dynamic_tag>
    """
  end
end
