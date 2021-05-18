ScheduleSchema =  Dry::Validation.JSON do
  required(:room_id).filled(:str?, included_in?: ScheduleSearch::DEFAULT_ROOMS)
  required(:start_at).filled(:int?)
  required(:expires_at).filled(:str?, max_size?: 19)
end
