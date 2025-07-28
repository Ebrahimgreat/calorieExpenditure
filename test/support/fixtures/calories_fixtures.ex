defmodule ElixirProject.CaloriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirProject.Calories` context.
  """

  @doc """
  Generate a calorie_calculation.
  """
  def calorie_calculation_fixture(attrs \\ %{}) do
    {:ok, calorie_calculation} =
      attrs
      |> Enum.into(%{
        activity_level: "some activity_level",
        age: 42,
        bmr: 120.5,
        height: 120.5,
        sex: "some sex",
        tdee: 120.5,
        weight: 120.5
      })
      |> ElixirProject.Calories.create_calorie_calculation()

    calorie_calculation
  end
end
