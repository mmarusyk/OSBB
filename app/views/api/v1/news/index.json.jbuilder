json.call(@news, :current_page)
json.call(@news, :total_pages)

json.news @news do |news|
  json.call(news, :id, :title, :short_description, :long_description, :is_visible, :image)
end
