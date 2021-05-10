module ResponseConcerns
  def json_error_response(messages, status = :failure)
  end

  def json_success_response(object, status = :ok)
    body = json_response_body('success', [], object)
    render status: status, json: body
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