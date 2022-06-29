defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}
  require Logger

  def mount(_params, _session, socket) do
    {:ok,
     assign(
       socket,
       score: 0,
       message: "Guess a number.",
       num: :rand.uniform(10)
     )}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
      <% end %>
    </h2>
    """
  end

  def handle_event(
        "guess",
        %{"number" => guess} = _data,
        %{assigns: %{num: num, score: score}} = socket
      ) do
    Logger.info("Random number: #{num}, Guess: #{guess}")

    {message, score} =
      case Integer.parse(guess) do
        {^num, _} -> {"You won! The number was #{guess}", score + 10}
        _ -> {"Your guess: #{guess}. Wrong. Guess again.", score - 1}
      end

    {:noreply,
     assign(
       socket,
       message: message,
       score: score,
       num: :rand.uniform(10)
     )}
  end
end
