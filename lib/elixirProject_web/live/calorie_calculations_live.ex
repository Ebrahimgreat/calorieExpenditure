defmodule ElixirProjectWeb.CalorieCalculationsLive do
  use ElixirProjectWeb, :live_view

  alias ElixirProject.Calories


  @spec mount(any(), any(), any()) :: {:ok, any()}
  def mount(_params, _session, socket) do
    if connected?(socket), do: Calories.subscribe()

    {:ok, assign(socket, %{ name: "", age: 25, height: 167, activityLevel: 1.2, sex: "male", bmr: 0.0, weight: 70, tdee: 0.0, users: Calories.list_calorie_calculations()})}

  end

  def handle_info({:recordCreated, record}, socket) do
    {:noreply, socket |> update(:users, fn users->[record | users]end)|> put_flash(:info, "#{record.name} inserted their record")}

  end






  @spec handle_event(<<_::80>>, map(), any()) :: {:noreply, any()}


  def handle_event("add", _params, socket) do
    activityLevel = Float.to_string(socket.assigns.activityLevel)

    newUser = %{ name: socket.assigns.name, age: socket.assigns.age, tdee: socket.assigns.tdee, weight: socket.assigns.weight, sex: socket.assigns.sex, height: socket.assigns.height, activity_level: activityLevel, bmr: socket.assigns.bmr}

    Calories.create_calorie_calculation(newUser)
    {:noreply, socket}


  end
  def handle_event("nameChange",%{ "name"=>name, "weight"=>weight, "age"=>age, "height"=>height, "sex"=>sex , "activityLevel"=>activityLevel }, socket) do

    age = case Integer.parse(age || "") do
    {num, _} -> num
    _ -> 0
  end
   height = case Float.parse(height) do
     {num, _} ->num
     _ -> 0
   end




 weight = case Float.parse(weight) do
   {num, _} ->num
   _ -> 0
 end
    bmr = if(sex == "male") do
  (10*weight) +(6.25 *height) -(5*age)+5
 else
   (10*weight)+ (6.25*height)-(5*age) -161


 end
 activityLevel = case Float.parse(activityLevel) do
  {num, _} ->num
  _ -> 0


 end
 tdee = activityLevel * bmr
    {:noreply, assign(socket, %{ name: name, age: age, height: height, bmr: bmr, weight: weight, sex: sex, activityLevel: activityLevel, tdee: tdee})}

  end

  def render(assigns) do
    ~H"""
    <h1 class="font-bold">
    TDEE Calculater
    </h1>
    <p class="font-extra-light">
    Use This calculater to calculate your Total Daily Expenditure
    </p>


    <.form  phx-change="nameChange">
    <label
    >Name</label>
    <.input name="name" value={@name}/>

    <label>
    Age
    </label>
    <.input type="number" value={@age} name="age"/>
    <label>
    Weight
    </label>
    <.input type="number" value={@weight} name="weight"/>

    <label>

    Sex
    </label>
    <.input type="select" options={[{"male","male"},{"female","female"}]} value={@sex} name="sex"/>
    <label>
    Height
    </label>
     <.input type="number" name="height" value={@height || 0}/>
     <label>
     Activity Level
     </label>
     <.input type="select" options={[{"Sedentary ",1.2},{"Lightly Active", 1.3},{"Moderately Active",1.55},{"Very Active",1.725},{"Extra Active",1.9}]} value={@activityLevel} name="activityLevel"/>


     </.form>



<p>


Your BMR is {@bmr}

</p>
Your  TDEE is {@tdee}

<.button phx-click="add">
        Add To List
        </.button>



<div class="w-full h-64 border overflow-y-auto">
<table>
<thead>
<tr>
<th class="px-4 py-2">
Name
</th>

<th class="px-4 py-2">
Age
</th>

<th class="px-4 py-2">
Activity Level
</th>

<th class="px-4 py-2">
Sex
</th>










<th class="px-4 py-2">
TDEE
</th>
</tr>
</thead>
<tbody>
<%=for user <-@users do %>
<tr>
<td class="px-4 py-2" ><%= user.name %></td>
<td class="px-4 py-2"> <%= user.age %> </td>
<td class="px-4 py-2"> <%= if user.activity_level == "1.2" do %>
 Sedentary
<% else %>
<%= if user.activity_level == "1.3" do %>

 Moderate Activity Level
 <% else %>
 <%= if user.activity_level == "1.55" do %>
 Moderate Activity Level
 <%else %>
 <%= if user.activity_level == "1.725" do %>
  Very Active
 <%else%>
 <%= if user.activity_level == "1.9" do %>
 Heavy Active
 <%end%>


 <%end%>



 <%end%>


 <%end %>

 <% end %>

</td>
<td class="px-4 py-2"> <%= user.sex %></td>
<td class="px-4 py"><%= Float.round(user.tdee,1)%></td>
</tr>
<% end %>

</tbody>
</table>
</div>

    """

  end

end
