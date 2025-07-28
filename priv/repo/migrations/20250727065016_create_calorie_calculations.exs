defmodule ElixirProject.Repo.Migrations.CreateCalorieCalculations do
  use Ecto.Migration

  def change do
    create table(:calorie_calculations) do
      add :age, :integer
      add :weight, :float
      add :height, :float
      add :sex, :string
      add :activity_level, :string
      add :bmr, :float
      add :tdee, :float

      timestamps(type: :utc_datetime)
    end
  end
end
