# frozen_string_literal: true

module Simpler
  class Router
    # The class responsible for defining and verifying the route
    class Route
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && path.match(@path)
      end
    end
  end
end
