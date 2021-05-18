class ScheduleSearch
  DEFAULT_MAX_PER_PAGE = 20
  DEFAULT_STATUS = %w(active canceled)
  DEFAULT_ROOMS = %w(uzumaki uchiha hyuga lee)
  

  def search
    params = prepare_search
    Schedule         
      .includes(params[:includes])
      .joins(params[:joins])
      .where(params[:rules])
      .where(params[:filters])
      .references(params[:includes])
      .order(params[:order])
      .page(params[:page])
      .per(params[:per_page])
  end

  def validate_time(params)
    return if params[:start_at].to_datetime.hour < 9
    return if params[:expires_at].to_datetime.hour > 18

    return "valid_time"
  end

  def validate_existent_schedule(params)
    Schedule.find_by(id: params[:id])
  end

  private

  def prepare_search
    {
      includes: options[:includes],
      rules: search_rules,
      filters: search_filter,
      order: order,
      page: options[:page],
      per_page: per_page
    }
  end

end