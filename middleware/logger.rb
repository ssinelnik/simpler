# frozen_string_literal: true

require 'logger'
require 'json'
require 'rack/utils'

# Rack middleware for HTTP request logging
class AppLogger
  def initialize(app, **options)
    @app = app
    @logger = Logger.new(options[:logdev] || STDOUT)
    @logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }
  end

  def call(env)
    request = Rack::Request.new(env)
    http_method = request.request_method
    full_path = request.fullpath
    params_hash = request.params

    route = Simpler.application.send(:instance_variable_get, :@router)
                       .route_for(env)
    handler_name = if route
                       "#{route.controller.name}##{route.action}"
                     else
                       "Unknown Handler"
                     end

    @logger.info("Request: #{http_method} #{full_path}")
    @logger.info("Handler: #{handler_name}")
    @logger.info("Parameters: #{params_hash.inspect}")

    status, headers, body = @app.call(env)

    status_text = "#{status} #{Rack::Utils::HTTP_STATUS_CODES[status] || 'Unknown'}"
    content_type = headers['Content-Type'] || 'unknown'

    template_name = env['simpler.template']
    template_part = if template_name
                      " #{template_name}.html.erb"
                    else
                      ""
                    end

    @logger.info("Response: #{status_text} [#{content_type}]#{template_part}")

    [status, headers, body]
  end
end
