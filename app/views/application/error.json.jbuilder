json.error do
  json.message @error.message
  json.backtrace @error.exception.backtrace if @error.exception && Rails.env.development?
end
