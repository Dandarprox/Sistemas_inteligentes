json.extract! user, :id, :age, :mood, :liking, :gender, :ocupation, :physhic, :created_at, :updated_at
json.url user_url(user, format: :json)
