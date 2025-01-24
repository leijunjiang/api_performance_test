10.times do |i|
  Task.create(
    title: "Task #{i + 1}",
    description: "Description for Task #{i + 1}",
    completed: [true, false].sample
  )
end
