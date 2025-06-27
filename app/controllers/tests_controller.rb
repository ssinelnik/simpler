# frozen_string_literal: true

# A controller for working with tests
class TestsController < Simpler::Controller
  def index
    render plain: "Plain text response"
  end
end
