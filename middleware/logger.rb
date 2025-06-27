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

    # @logger.info("#{env['REQUEST_METHOD']} #{env['PATH_INFO']} - #{Time.now}")
    # @app.call(env)

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

    @logger.info("Request: #{http_method} #{full_path}")
    @logger.info("Handler: #{handler_name}")
    @logger.info("Parameters: #{params_hash.inspect}")

    status, headers, body = @app.call(env)

    @logger.info("Response: #{status} [#{content_type}]#{template_file ? " #{template_file}" : ''}")
    # @logger.info("Response: #{status}")


    [status, headers, body]
  end
end
