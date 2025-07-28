defmodule ElixirProject.Calories do
  @moduledoc """
  The Calories context.
  """

  import Ecto.Query, warn: false
  alias ElixirProject.Repo

  alias ElixirProject.Calories.CalorieCalculation

  @doc """
  Returns the list of calorie_calculations.

  ## Examples

      iex> list_calorie_calculations()
      [%CalorieCalculation{}, ...]

  """
  def list_calorie_calculations do
    Repo.all(CalorieCalculation)
  end

  @doc """
  Gets a single calorie_calculation.

  Raises `Ecto.NoResultsError` if the Calorie calculation does not exist.

  ## Examples

      iex> get_calorie_calculation!(123)
      %CalorieCalculation{}

      iex> get_calorie_calculation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_calorie_calculation!(id), do: Repo.get!(CalorieCalculation, id)

  @doc """
  Creates a calorie_calculation.

  ## Examples

      iex> create_calorie_calculation(%{field: value})
      {:ok, %CalorieCalculation{}}

      iex> create_calorie_calculation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_calorie_calculation(attrs \\ %{}) do
    %CalorieCalculation{}
    |> CalorieCalculation.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:recordCreated)
  end

  @doc """
  Updates a calorie_calculation.

  ## Examples

      iex> update_calorie_calculation(calorie_calculation, %{field: new_value})
      {:ok, %CalorieCalculation{}}

      iex> update_calorie_calculation(calorie_calculation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_calorie_calculation(%CalorieCalculation{} = calorie_calculation, attrs) do
    calorie_calculation
    |> CalorieCalculation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a calorie_calculation.

  ## Examples

      iex> delete_calorie_calculation(calorie_calculation)
      {:ok, %CalorieCalculation{}}

      iex> delete_calorie_calculation(calorie_calculation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_calorie_calculation(%CalorieCalculation{} = calorie_calculation) do
    Repo.delete(calorie_calculation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking calorie_calculation changes.

  ## Examples

      iex> change_calorie_calculation(calorie_calculation)
      %Ecto.Changeset{data: %CalorieCalculation{}}

  """
  def change_calorie_calculation(%CalorieCalculation{} = calorie_calculation, attrs \\ %{}) do
    CalorieCalculation.changeset(calorie_calculation, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(ElixirProject.PubSub, "calorie_calculations")

  end


  defp broadcast({:ok, record},event) do
    Phoenix.PubSub.broadcast(ElixirProject.PubSub, "calorie_calculations",{event,record})
    {:ok, record}
  end
end
