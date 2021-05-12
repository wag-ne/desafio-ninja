class ScheduleSearch
  DEFAULT_MAX_PER_PAGE = 20
  DEFAULT_STATUS = %w(active canceled)
  DEFAULT_ROOMS = %w(uzumaki uchiha hyuga lee)
  

  def search
    Schedule.all
  end

  def validate_time(params)
    return if params[:start_at].to_datetime.hour < 9.hour
    return if params[:expires_at].to_datetime.hour > 18.hour
    
    return "valid_time"
  end

end