def render_error_body(code, message)
  {error: code,
   message: message}.to_json
end
