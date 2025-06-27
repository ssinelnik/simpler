# frozen_string_literal: true

require 'json'
require_relative 'view'

module Simpler
  # The controller is responsible for receiving HTTP requests
  class Controller
    attr_reader :name

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] ||= 'text/html'
    end

    def write_response
      content = if defined?(@body) && @body
                  @body
                else
                  render_body
                end
      @response.write(content)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(spec = nil)
      case spec
      when Hash
        if spec.key?(:plain)
          @response['Content-Type'] ='text/plain'
          @body = spec[:plain].to_s
        elsif spec.key?(:json)
          @response['Content-Type'] = 'application/json'
          @body = spec[:json].to_json
        else
          raise ArgumentError, "Unsupported render format: #{spec.keys.inspect}"
        end
      when String, Symbol
        @request.env['simpler.template'] = spec.to_s
      else
        raise ArgumentError, "Invalid render argument: #{spec.inspect}"
      end
    end
  end
end
