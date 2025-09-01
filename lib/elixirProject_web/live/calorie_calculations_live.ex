defmodule ElixirProjectWeb.CalorieCalculationsLive do
  use ElixirProjectWeb, :live_view
  alias ElixirProject.Calories

  @spec mount(any(), any(), any()) :: {:ok, any()}
  def mount(_params, _session, socket) do
    if connected?(socket), do: Calories.subscribe()
    {:ok, assign(socket, %{
      age: 25,
      height: 167,
      activityLevel: 1.2,
      sex: "male",
      bmr: 0.0,
      weight: 70,
      tdee: 0.0,
      users: Calories.list_calorie_calculations()
    })}
  end

  def handle_info({:recordCreated, record}, socket) do
    {:noreply, socket
     |> update(:users, fn users -> [record | users] end)
     |> put_flash(:info, "#{record.name} inserted their record")}
  end

  @spec handle_event(<<_::80>>, map(), any()) :: {:noreply, any()}
  def handle_event("nameChange", %{
    "weight" => weight,
    "age" => age,
    "height" => height,
    "sex" => sex,
    "activityLevel" => activityLevel
  }, socket) do
    age = case Integer.parse(age || "") do
      {num, _} -> num
      _ -> 0
    end

    height = case Float.parse(height) do
      {num, _} -> num
      _ -> 0
    end

    weight = case Float.parse(weight) do
      {num, _} -> num
      _ -> 0
    end

    bmr = if(sex == "male") do
      (10 * weight) + (6.25 * height) - (5 * age) + 5
    else
      (10 * weight) + (6.25 * height) - (5 * age) - 161
    end

    activityLevel = case Float.parse(activityLevel) do
      {num, _} -> num
      _ -> 0
    end

    tdee = activityLevel * bmr

    {:noreply, assign(socket, %{
      age: age,
      height: height,
      bmr: bmr,
      weight: weight,
      sex: sex,
      activityLevel: activityLevel,
      tdee: tdee
    })}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-pink-700 via-purple-700 to-indigo-800">
      <div class="container mx-auto px-4 py-8">
        <!-- Header Section -->
        <div class="text-center mb-12">
          <div class="inline-flex items-center justify-center w-20 h-20 bg-white/20 rounded-full mb-6 backdrop-blur-sm">
            <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
            </svg>
          </div>
          <h1 class="font-bold text-4xl md:text-5xl text-white mb-4 tracking-tight">
            TDEE Calculator
          </h1>
          <p class="text-lg text-pink-100 opacity-90 leading-relaxed max-w-2xl mx-auto">
            <span class="font-semibold">Total Daily Energy Expenditure</span> is the number of calories your body burns in a day, including everything from basic functions like breathing and digestion to physical activity. Knowing your TDEE helps you understand how much you need to eat to maintain, lose, or gain weight based on your goals.
          </p>
        </div>

        <div class="max-w-4xl mx-auto">
          <div class="grid lg:grid-cols-2 gap-8">
            <!-- Input Form Card -->
            <div class="bg-white/10 backdrop-blur-lg rounded-2xl p-8 border border-white/20 shadow-2xl">
              <h2 class="text-2xl font-bold text-white mb-6 flex items-center">
                <svg class="w-6 h-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                </svg>
                Your Information
              </h2>

              <.form phx-change="nameChange" class="space-y-6">
                <div class="grid md:grid-cols-2 gap-4">
                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-pink-100">Age (years)</label>
                    <.input
                      type="number"
                      value={@age}
                      name="age"
                      class="w-full px-4 py-3 bg-white/20 border border-white/30 rounded-lg text-white placeholder-pink-200 focus:ring-2 focus:ring-pink-400 focus:border-transparent backdrop-blur-sm"
                    />
                  </div>

                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-pink-100">Weight (kg)</label>
                    <.input
                      type="number"
                      value={@weight}
                      name="weight"
                      class="w-full px-4 py-3 bg-white/20 border border-white/30 rounded-lg text-white placeholder-pink-200 focus:ring-2 focus:ring-pink-400 focus:border-transparent backdrop-blur-sm"
                    />
                  </div>
                </div>

                <div class="grid md:grid-cols-2 gap-4">
                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-pink-100">Height (cm)</label>
                    <.input
                      type="number"
                      name="height"
                      value={@height || 0}
                      class="w-full px-4 py-3 bg-white/20 border border-white/30 rounded-lg text-white placeholder-pink-200 focus:ring-2 focus:ring-pink-400 focus:border-transparent backdrop-blur-sm"
                    />
                  </div>

                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-pink-100">Sex</label>
                    <.input
                      type="select"
                      options={[{"male","male"},{"female","female"}]}
                      value={@sex}
                      name="sex"
                      class="w-full px-4 py-3 bg-white/20 border border-white/30 rounded-lg text-white focus:ring-2 focus:ring-pink-400 focus:border-transparent backdrop-blur-sm"
                    />
                  </div>
                </div>

                <div class="space-y-2">
                  <label class="block text-sm font-medium text-pink-100">Activity Level</label>
                  <.input
                    type="select"
                    options={[
                      {"Sedentary (little/no exercise)", 1.2},
                      {"Lightly Active (light exercise 1-3 days/week)", 1.3},
                      {"Moderately Active (moderate exercise 3-5 days/week)", 1.55},
                      {"Very Active (hard exercise 6-7 days/week)", 1.725},
                      {"Extra Active (very hard exercise, physical job)", 1.9}
                    ]}
                    value={@activityLevel}
                    name="activityLevel"
                    class="w-full px-4 py-3 bg-white/20 border border-white/30 rounded-lg text-white focus:ring-2 focus:ring-pink-400 focus:border-transparent backdrop-blur-sm"
                  />
                </div>
              </.form>

              <p class="mt-6 text-sm text-pink-200 italic text-center">
  ℹ️ This is an estimate that gives you a starting number.
  Your true maintenance calories can only be found by tracking your weight over time while eating around this amount.
  For example, if your goal is weight loss, aim to consistently eat a bit below this number; if your goal is weight gain, aim to eat above it.
</p>
            </div>

            <!-- Results Card -->
            <div class="bg-white/10 backdrop-blur-lg rounded-2xl p-8 border border-white/20 shadow-2xl">
              <h2 class="text-2xl font-bold text-white mb-6 flex items-center">
                <svg class="w-6 h-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                </svg>
                Your Results
              </h2>

              <div class="space-y-6">
                <!-- BMR Card -->
                <div class="bg-gradient-to-r from-pink-500/30 to-purple-500/30 rounded-xl p-6 border border-white/10">
                  <div class="flex items-center justify-between">
                    <div>
                      <h3 class="text-lg font-semibold text-white mb-1">Basal Metabolic Rate</h3>
                      <p class="text-pink-200 text-sm">Calories burned at rest</p>
                    </div>
                    <div class="text-right">
                      <div class="text-3xl font-bold text-white"><%= trunc(@bmr) %></div>
                      <div class="text-pink-200 text-sm">calories/day</div>
                    </div>
                  </div>
                </div>

                <!-- TDEE Card -->
                <div class="bg-gradient-to-r from-purple-500/30 to-indigo-500/30 rounded-xl p-6 border border-white/10">
                  <div class="flex items-center justify-between">
                    <div>
                      <h3 class="text-lg font-semibold text-white mb-1">Total Daily Energy Expenditure</h3>
                      <p class="text-purple-200 text-sm">Total calories burned per day</p>
                    </div>
                    <div class="text-right">
                      <div class="text-3xl font-bold text-white"><%= trunc(@tdee) %></div>
                      <div class="text-purple-200 text-sm">calories/day</div>
                    </div>
                  </div>
                </div>

                <div class="bg-gradient-to-r from-indigo-500/30 to-blue-500/30 rounded-xl p-6 border border-white/10">
                <h3 class="text-lg font-semibold text-white mb-4">Calculation Formulas</h3>
                <div class="space-y-4 text-sm">
                  <div class="bg-white/10 rounded-lg p-4">
                    <h4 class="font-semibold text-blue-200 mb-2">BMR (Mifflin-St Jeor Equation):</h4>
                    <div class="font-mono text-blue-100 text-xs">
                      For men: BMR = (10 × weight) + (6.25 × height) - (5 × age) + 5<br/>
                      For women: BMR = (10 × weight) + (6.25 × height) - (5 × age) - 161
                    </div>
                  </div>

                  <div class="bg-white/10 rounded-lg p-4">
                    <h4 class="font-semibold text-blue-200 mb-2">TDEE (Total Daily Energy Expenditure):</h4>
                    <div class="font-mono text-blue-100 text-xs">
                      TDEE = BMR × Activity Level
                    </div>
                    <div class="font-mono text-blue-100 text-xs mt-1">
                      Example: <%= trunc(@bmr) %> × <%= @activityLevel %> = <%= trunc(@tdee) %>
                    </div>
                  </div>
                </div>
              </div>




              </div>
            </div>
          </div>

          <!-- Activity Level Guide -->
          <div class="mt-8 bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 shadow-2xl">
            <h3 class="text-xl font-bold text-white mb-4 flex items-center">
              <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
              Activity Level Guide
            </h3>
            <div class="grid md:grid-cols-2 lg:grid-cols-5 gap-3">
              <div class="bg-white/10 rounded-lg p-3 text-center">
                <div class="text-sm font-semibold text-white">Sedentary</div>
                <div class="text-xs text-pink-200 mt-1">Desk job, little exercise</div>
              </div>
              <div class="bg-white/10 rounded-lg p-3 text-center">
                <div class="text-sm font-semibold text-white">Lightly Active</div>
                <div class="text-xs text-pink-200 mt-1">Light exercise 1-3 days</div>
              </div>
              <div class="bg-white/10 rounded-lg p-3 text-center">
                <div class="text-sm font-semibold text-white">Moderately Active</div>
                <div class="text-xs text-pink-200 mt-1">Exercise 3-5 days</div>
              </div>
              <div class="bg-white/10 rounded-lg p-3 text-center">
                <div class="text-sm font-semibold text-white">Very Active</div>
                <div class="text-xs text-pink-200 mt-1">Hard exercise 6-7 days</div>
              </div>
              <div class="bg-white/10 rounded-lg p-3 text-center">
                <div class="text-sm font-semibold text-white">Extra Active</div>
                <div class="text-xs text-pink-200 mt-1">Very hard exercise + physical job</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
