# frozen_string_literal: true

require 'pathname'
require_relative 'simpler/application'

# The main module of the Simpler web framework
module Simpler
  class << self
    def application
      Application.instance
    end

    def root
      Pathname.new(File.expand_path('..', __dir__))
    end
  end
end
