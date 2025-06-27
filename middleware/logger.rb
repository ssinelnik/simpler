# frozen_string_literal: true

require 'logger'
require 'json'

# Rack middleware for HTTP request logging
class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    @logger.info("#{env['REQUEST_METHOD']} #{env['PATH_INFO']} - #{Time.now}")
    @app.call(env)
  end
end
