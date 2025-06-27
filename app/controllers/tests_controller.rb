# frozen_string_literal: true

# A controller for working with tests
class TestsController < Simpler::Controller
  def index
    status 201
    render plain: "Plain text response"
  end

  def not_found
    status 404
    render plain: "Resource not found"
  end
end
