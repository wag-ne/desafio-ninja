class ScheduleSerializer < ActiveModel::Serializer
  attributes :room, :status, :start_at, :expires_at
end