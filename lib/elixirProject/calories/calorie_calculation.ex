defmodule ElixirProject.Calories.CalorieCalculation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "calorie_calculations" do
    field :name, :string
    field :age, :integer
    field :weight, :float
    field :height, :float
    field :sex, :string
    field :activity_level, :string
    field :bmr, :float
    field :tdee, :float


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(calorie_calculation, attrs) do
    calorie_calculation
    |> cast(attrs, [:age, :name, :weight, :height, :sex, :activity_level, :bmr, :tdee])
    |> validate_required([:age, :weight, :height, :sex, :activity_level, :bmr, :tdee])
  end
end
