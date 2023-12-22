defmodule Counter do
  @moduledoc """
  Counter keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  use CounterWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :val, 0)}
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dev", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="teext-4xl font-bold text-center">The count is: <%= @val %></h1>

      <p class="text-center">
        <.button phx-click="dec">-</.button>
        <.button phx-click="inc">+</.button>
      </p>
    </div>
    """
  end
end
