class SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[ show edit update destroy ]

  def index
    result = ScheduleIndexSchema.call(params)

    if result.failure?
      return json_error_response(result.messages, :bad_request)
    end

    json_pagination(
      ScheduleSearch.new(),
      ScheduleSerializer
    )
  end

  def show
    json_success_response(
      ScheduleSerializer.new(params)
    )
  end

  def create
    room = ScheduleSearch.room_for_user(params[:room])
    if room.nil?
      json_error_response("Room is not available", :bad_request)
      return
    end

    result = ScheduleCreateSchema.call(params)
    if result.failure?
      return json_error_response(result.messages, :bad_request)
    end

    operation = Operations::Schedule::Create.new(user, room)
    result = operation.call(result)

    if result.failure?
      return json_error_response(result.translated_errors, :unprocessable_entity)
    end

    new_schedule = result.data[:new_schedule]
    json_success_response(ScheduleSerializer.new(new_schedule), :created)
  end

  def update
    schedule = ScheduleSearch.existent_schedule(params)

    if schedule.nil?
      return json_error_response("Not exist an existent schedule", :wip)
    end

    result = ScheduleUpdateSchema.call(params)
    if result.failure?
      return json_error_response(result.messages, :bad_request)
    end

    operation = Operations::Schedule::Update.new(user, room)
    result = operation.call(result)

    if result.failure?
      return json_error_response(result.translated_errors, :unprocessable_entity)
    end

    new_schedule = result.data[:updated_schedule]
    json_success_response(ScheduleSerializer.new(new_schedule), :updated)
  end

  def destroy
    schedule = ScheduleSearch.existent_schedule(params)

    if schedule.nil?
      return json_error_response("Not exist an existent schedule to cancel", :wip)
    end

    operation = Operations::Schedule::Cancel.new(user, room)
    result = operation.call(result)

    if result.failure?
      return json_error_response(result.translated_errors, :unprocessable_entity)
    end

    new_schedule = result.data[:updated_schedule]
    json_success_response(ScheduleSerializer.new(new_schedule), :updated)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def schedule_params
      params.require(:schedule).permit(:room_id, :status, :start_at, :expires_at)
    end
end
