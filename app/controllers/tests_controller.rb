# frozen_string_literal: true

# A controller for working with tests
class TestsController < Simpler::Controller
  def index
    status 201
    headers['Content-Type'] = 'text/plain'
    render plain: "Plain text response"
  end

  def not_found
    status 404
    headers['X-Correlation-ID'] = request.params['id']
    render plain: "Resource not found"
  end

  def show
    test_id = params[:id]
    @test = Test[test_id]
    render plain: "Test ID is #{test_id}"
  end
end
