class ApiError
  attr_reader :code
  attr_reader :message
  attr_reader :exception

  def initialize(code:, message:, exception: nil)
    @code = code
    @message = message
    @exception = exception
  end
end
