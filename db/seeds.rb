Todo.find_or_create_by!(title: "Try the factory") do |t|
  t.completed = false
end
