defmodule ElixirProjectWeb.Exercise do
  use ElixirProjectWeb, :live_view
  @spec mount(any(), any(), any()) :: nil
  def mount(_params, _session, socket) do
    {:ok, socket}

  end
  def render(assigns) do
    ~H"""
    <h1> Hello </h1>
    """

  end


end
