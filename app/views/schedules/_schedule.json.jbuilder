json.extract! schedule, :id, :room_id, :status, :start_at, :expires_at, :created_at, :updated_at
json.url schedule_url(schedule, format: :json)
