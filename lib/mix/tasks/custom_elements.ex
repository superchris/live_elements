defmodule Mix.Tasks.CustomElements do
  @moduledoc "Generates custom elements helper functions from a manifest file"
  def run([ce_manifest_path, module, helper_path]) do
    %{"modules" => modules} = File.read!(ce_manifest_path) |> Jason.decode!()
    File.write!(helper_path, helper_functions(module, modules |> find_custom_elements()))
  end

  def helper_functions(module, custom_elements) do
    EEx.eval_string(
      """
      defmodule <%= module %> do
        <%= for custom_element <- custom_elements do %>
        def <%= custom_element["tagName"] |> String.replace("-", "_") %>(assigns) do
          <%= output_tag(custom_element)%>
        end
        <% end %>
      end
      """,
      module: module,
      custom_elements: custom_elements
    )
  end

  def output_tag(%{"tagName" => tag, "events" => events}) do
    "~H\"<#{tag}></#{tag}>\""
  end

  def find_custom_elements(modules) do
    modules
    |> Enum.map(& &1["declarations"])
    |> Enum.concat()
    |> Enum.filter(& &1["customElement"])
    |> IO.inspect()
  end
end
