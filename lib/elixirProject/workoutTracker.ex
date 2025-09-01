defmodule Crohnjobs.WorkoutTracker do
  def programme(%{ date: date, exercises: exercises}) do
   case File.open("workout.txt",[:write, :utf8]) do
     {:ok, file}->
       IO.puts(file, "Workout Date, #{date}")
     Enum.each(exercises, fn x->Enum.each(x.workout, fn set->IO.puts(file, "Exercise: #{x.exercise}, Set,#{set.set},weight: #{set.weight}, reps:#{set.reps}")end)end)
     totalWeight = exercises|> Enum.flat_map(fn x-> x.workout end)|> Enum.map(fn workout-> workout.weight end)|>Enum.sum()
     IO.puts(file, "Total Weight #{totalWeight}")
     File.close(file)
     {:error, reason}->IO.puts("Error opening the file, #{reason}")
   end


  end

 end
