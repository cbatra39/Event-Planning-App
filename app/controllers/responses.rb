module Responses
  def success(message = nil, data: nil,id: nil, email: nil, image_url: nil, event_category: nil,events:nil)
    response = { status: 200 }
    response[:message] = message if message.present?
    response[:data] = data if data.present?
    response[:email] = email if email.present?
    response[:image_url] = image_url if image_url.present?
    response[:id] = id if id.present?
    response[:events] = events if events.present?
    response[:event_category] = event_category if event_category.present?
    render json: response, status: :ok
  end

  def success_201(message, status_code: 201)
    render json: {
      status: status_code,
      message: message
    }, status: status_code
  end
  


  def error(message, status_code: 422)
    render json: {
      status: status_code,
      error: message
    }, status: status_code
  end

  def error_500(message)
    error(message, status_code: 500)
  end
  
  def error_401(message)
    error(message, status_code: 401)
  end
  
  def error_402(message)
    error(message, status_code: 402)
  end
  
  def error_403(message)
    error(message, status_code: 403)
  end
  
  def error_404(message)
    error(message, status_code: 404)
  end
  
  def error_400(message)
    error(message, status_code: 400)
  end
end
