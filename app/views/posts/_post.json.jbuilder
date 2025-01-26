json.extract! post, :id, :user_id, :post, :title, :category, :created_at, :updated_at
json.url post_url(post, format: :json)
