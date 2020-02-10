defmodule Servy do
  def hello(name) do
    "Howdy, #{name}!"
    # :world
  end
end

IO.puts Servy.hello("Elixir")