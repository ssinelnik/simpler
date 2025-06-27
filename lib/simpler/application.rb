# frozen_string_literal: true

require 'yaml'
require 'singleton'
require 'sequel'
require_relative 'router'
require_relative 'controller'

module Simpler
  # Main application class that handles routing and request processing
  class Application
    include Singleton

    attr_reader :db

    def initialize
      @router = Router.new
      @db = nil
    end

    def bootstrap!
      setup_database
      require_app
      require_routes
    end

    def call(env)
      route = @router.route_for(env)

      unless route
        return not_found_response
      end

      controller = route.controller.new(env)
      action = route.action

      make_response(controller, action)
    end

    def routes(&block)
      @router.instance_eval(&block)
    end

    private

    def not_found_response
      body = "404 Not Found"
      Rack::Response.new(body, 404, 'Content-Type' => 'text/plain').finish
    end

    def require_app
      Dir["#{Simpler.root}/app/**/*.rb"].sort.each { |file| require file }
    end

    def require_routes
      require Simpler.root.join('config/routes')
    end

    def make_response(controller, action)
      controller.make_response(action)
    end

    def setup_database
      config_path = Simpler.root.join('config/database.yaml')
      database_config = YAML.load_file(config_path)
      database_file = Simpler.root.join(database_config['database'])
      database_config['database'] = database_file

      @db = Sequel.connect(database_config)
    end
  end
end
