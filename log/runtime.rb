# frozen_string_literal: true

# Injects X-Runtime header with request duration
class Runtime
  def initialize(app)
    @app = app
  end

  def call(env)
    start = Time.now
    status, headers, body = @app.call(env)
    headers['X-Runtime'] = format('%<time>.6fs', time: Time.now - start)
    [status, headers, body]
  end
end
