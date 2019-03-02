json.success true
json.page_meta @page_meta
json.todos do |json|
  json.array! @todos, partial: 'todos/summary', as: :todo
end