class SchedulesController < ApplicationController
  before_action :schedule, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    # result = ScheduleIndexSchema.call(params)

    # if result.failure?
    #   return json_error_response(result.messages, :bad_request)
    # end

    json_pagination(
      ScheduleSearch.new.search,
      ScheduleSerializer
    )
  end

  def show
    json_success_response(
      ScheduleSerializer.new(schedule)
    )
  end

  def create
    time = ScheduleSearch.new.validate_time(params)

    if time.nil?
      json_error_response("Please, use a valid time", :bad_request)
      return
    end
    
    # result = ScheduleSchema.call(params)
    # if result.failure?
    #   return json_error_response(result.messages, :bad_request)
    # end
    # operation = Operations::Schedule::Create.new(user, room)
    # result = operation.call(result)

    result = Schedule.create(
      room_id: params[:room_id],
      status: 'active',
      start_at: params[:start_at], 
      expires_at: params[:expires_at]
    )
    # binding.pry
    if result.id.nil?
      return json_error_response(result.translated_errors, :unprocessable_entity)
    end

    # new_schedule = result.data[:new_schedule]
    json_success_response(ScheduleSerializer.new(result), :created)
  end

  def update
    schedule = ScheduleSearch.new.validate_existent_schedule(params)

    if schedule.nil?
      return json_error_response("Not exist an existent schedule", :bad_request)
    end

    result = schedule.update(
      room_id: params[:room_id],
      status: 'active',
      start_at: params[:start_at], 
      expires_at: params[:expires_at]
    )
    # binding.pry
    # result = ScheduleSchema.call(params)
    # if result.failure?
    #   return json_error_response(result.messages, :bad_request)
    # end

    # operation = Operations::Schedule::Update.new(user, room)
    # result = operation.call(result)

    if !result.present?
      return json_error_response(result.translated_errors, :unprocessable_entity)
    end

    # new_schedule = result.data[:updated_schedule]
    json_success_response(ScheduleSerializer.new(schedule), :ok)
  end

  def destroy
    if @schedule.nil?
      return json_error_response("Not exist an existent schedule to cancel")
    end

    @schedule.update!(status: false)
    json_success_response(ScheduleSerializer.new(@schedule))
  end

  private

  def schedule
    @schedule ||= Schedule.find_by(id: params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(:room_id, :status, :start_at, :expires_at)
  end
end
