class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :room, :status, :start_at, :expires_at
end