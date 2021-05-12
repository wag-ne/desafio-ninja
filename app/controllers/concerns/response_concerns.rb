module ResponseConcerns
  def json_error_response(messages, status = :unprocessable_entity)
    body = json_response_body('failure', messages)
    render status: status, json: body
  end

  def json_success_response(object, status = :ok)
    body = json_response_body('success', [], object)
    render status: status, json: body
  end

  def json_pagination(objects, serializer, status = :ok)
    render json: {
      pagination: {
        found: objects.total_count,
        pages: objects.total_pages,
        current_page: objects.current_page,
        per_page: objects.limit_value
      },
      entries: serialize_array(objects, serializer)
    }, status: status
  end

  private

  def json_response_body(result, messages = [], data = nil)
    {
      result: result,
      messages: messages,
      data: data
    }
  end
end