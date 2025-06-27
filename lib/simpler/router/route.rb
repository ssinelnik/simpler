# frozen_string_literal: true

module Simpler
  class Router
    # The class responsible for defining and verifying the route
    class Route
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @pattern = Regexp.new(pattern(path))
        @controller = controller
        @action = action
      end

      def match?(method, path)
        return false unless @method == method
        @match_data = @pattern.match(path)
      end

      def pattern(path)
        '^' +
          path
            .gsub('.', '\.')
            .gsub(/:(\w+)/, '(?<\1>[^/]+)')
            + '$'
      end

      def params
        return {} unless @match_data
        @match_data.named_captures.transform_keys(&:to_sym)
      end
    end
  end
end
