ScheduleIndexSchema =  Dry::Validation.Params do
    optional(:page).maybe(:int?)
    optional(:per_page).maybe(:int?, lteq?: ScheduleSearch::DEFAULT_MAX_PER_PAGE)
    optional(:status).filled(:str? included_in?: ScheduleSearch::DEFAULT_STATUS)
    optional(:date).filled(:date_time?)
    optional(room).filled(:str? included_in?: ScheduleSearch::DEFAULT_ROOMS)
end
