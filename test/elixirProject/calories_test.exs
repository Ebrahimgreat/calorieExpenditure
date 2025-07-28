defmodule ElixirProject.CaloriesTest do
  use ElixirProject.DataCase

  alias ElixirProject.Calories

  describe "calorie_calculations" do
    alias ElixirProject.Calories.CalorieCalculation

    import ElixirProject.CaloriesFixtures

    @invalid_attrs %{age: nil, weight: nil, height: nil, sex: nil, activity_level: nil, bmr: nil, tdee: nil}

    test "list_calorie_calculations/0 returns all calorie_calculations" do
      calorie_calculation = calorie_calculation_fixture()
      assert Calories.list_calorie_calculations() == [calorie_calculation]
    end

    test "get_calorie_calculation!/1 returns the calorie_calculation with given id" do
      calorie_calculation = calorie_calculation_fixture()
      assert Calories.get_calorie_calculation!(calorie_calculation.id) == calorie_calculation
    end

    test "create_calorie_calculation/1 with valid data creates a calorie_calculation" do
      valid_attrs = %{age: 42, weight: 120.5, height: 120.5, sex: "some sex", activity_level: "some activity_level", bmr: 120.5, tdee: 120.5}

      assert {:ok, %CalorieCalculation{} = calorie_calculation} = Calories.create_calorie_calculation(valid_attrs)
      assert calorie_calculation.age == 42
      assert calorie_calculation.weight == 120.5
      assert calorie_calculation.height == 120.5
      assert calorie_calculation.sex == "some sex"
      assert calorie_calculation.activity_level == "some activity_level"
      assert calorie_calculation.bmr == 120.5
      assert calorie_calculation.tdee == 120.5
    end

    test "create_calorie_calculation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Calories.create_calorie_calculation(@invalid_attrs)
    end

    test "update_calorie_calculation/2 with valid data updates the calorie_calculation" do
      calorie_calculation = calorie_calculation_fixture()
      update_attrs = %{age: 43, weight: 456.7, height: 456.7, sex: "some updated sex", activity_level: "some updated activity_level", bmr: 456.7, tdee: 456.7}

      assert {:ok, %CalorieCalculation{} = calorie_calculation} = Calories.update_calorie_calculation(calorie_calculation, update_attrs)
      assert calorie_calculation.age == 43
      assert calorie_calculation.weight == 456.7
      assert calorie_calculation.height == 456.7
      assert calorie_calculation.sex == "some updated sex"
      assert calorie_calculation.activity_level == "some updated activity_level"
      assert calorie_calculation.bmr == 456.7
      assert calorie_calculation.tdee == 456.7
    end

    test "update_calorie_calculation/2 with invalid data returns error changeset" do
      calorie_calculation = calorie_calculation_fixture()
      assert {:error, %Ecto.Changeset{}} = Calories.update_calorie_calculation(calorie_calculation, @invalid_attrs)
      assert calorie_calculation == Calories.get_calorie_calculation!(calorie_calculation.id)
    end

    test "delete_calorie_calculation/1 deletes the calorie_calculation" do
      calorie_calculation = calorie_calculation_fixture()
      assert {:ok, %CalorieCalculation{}} = Calories.delete_calorie_calculation(calorie_calculation)
      assert_raise Ecto.NoResultsError, fn -> Calories.get_calorie_calculation!(calorie_calculation.id) end
    end

    test "change_calorie_calculation/1 returns a calorie_calculation changeset" do
      calorie_calculation = calorie_calculation_fixture()
      assert %Ecto.Changeset{} = Calories.change_calorie_calculation(calorie_calculation)
    end
  end
end
