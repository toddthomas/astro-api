class ApplicationController < ActionController::API
  rescue_from NotFoundError, ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from SimbadError, with: :render_bad_gateway_response
  rescue_from SimbadParserError, with: :render_internal_server_error_response
  rescue_from InvalidQueryError, with: :render_bad_request_response

  private

  def render_not_found_response(exception)
    render_error_response(code: :not_found, exception: exception)
  end

  def render_bad_gateway_response(exception)
    render_error_response(code: :bad_gateway, exception: exception)
  end

  def render_internal_server_error_response(exception)
    render_error_response(code: :internal_server_error, exception: exception)
  end

  def render_bad_request_response(exception)
    render_error_response(code: :bad_request, exception: exception)
  end

  def render_error_response(code:, exception:)
    @error = ApiError.new(code: code, message: exception.message)
    render 'error', formats: [:json], status: code
  end
end
