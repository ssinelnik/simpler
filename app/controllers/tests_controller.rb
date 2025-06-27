# frozen_string_literal: true

# A controller for working with tests
class TestsController < Simpler::Controller
  def index
    @tests = Test.all
  end
end
