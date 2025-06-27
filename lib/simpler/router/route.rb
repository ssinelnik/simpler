# frozen_string_literal: true

module Simpler
  class Router
    # The class responsible for defining and verifying the route
    class Route
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @controller = controller
        @action = action

        @pattern = /\A#{pattern(path)}\z/
      end

      def match?(method, path)
        return false unless @method == method
        @match_data = @pattern.match(path)
      end

      # Преобразует строку маршрута с динамическими параметрами
      def pattern(path)
        path.split('/').map do |segment|
          if segment.start_with?(':')
            name = segment[1..-1]
            "(?<#{name}>[^/]+)"
          else
            Regexp.escape(segment)
          end
        end.join('/')
      end

      def params
        return {} unless @match_data
        @match_data.named_captures.transform_keys(&:to_sym)
      end
    end
  end
end
