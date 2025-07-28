defmodule ElixirProject.Repo.Migrations.AddNameToCalorieCalculations do
  use Ecto.Migration

  def change do
    alter table(:calorie_calculations) do
      add :name, :string
    end

  end
end
