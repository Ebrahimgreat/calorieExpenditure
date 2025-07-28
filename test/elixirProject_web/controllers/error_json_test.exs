defmodule ElixirProjectWeb.ErrorJSONTest do
  use ElixirProjectWeb.ConnCase, async: true

  test "renders 404" do
    assert ElixirProjectWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ElixirProjectWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
