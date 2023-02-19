defmodule MacroExperiments do
  defmacro play do
    for meth <- ["one", "two", "three"] do
      IO.inspect(meth)

      quote do
        def unquote(meth |> String.to_atom())() do
          IO.puts(unquote(meth))
          assigns = []
          IO.inspect(assigns)
          # ~H"""
          #   <div></div>
          # """
        end
      end
    end

    # def one(), do: "one"
    # def two(), do: "two"
  end

  defmacro stuff(numbers) do
    # numbers
    # |> Enum.map(fn number ->
      quote do
        IO.puts(unquote(numbers))
      end
    # end)
  end
end

defmodule Victim do
  require MacroExperiments
  # MacroExperiments.stuff([1, 2, 3])
end
