# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../app/controllers/session_controller'

describe 'Trip Route with Session Management' do
  def setup
    setup_trip_data
    setup_session_controller
  end

  it 'HAPPY: sets the trip data in the session' do
    expect(@session[:trip].origin).must_equal @origin
    expect(@session[:trip].destination).must_equal @destination
    expect(@session[:trip].strategy).must_equal @strategy
    expect(@result).must_equal "Location set: #{@session[:trip]}"
  end

  it 'HAPPY: retrieves the trip data from the session' do
    expect(@controller.user_origin).must_equal @origin
    expect(@controller.user_destination).must_equal @destination
    expect(@controller.user_strategy).must_equal @strategy
  end

  it 'HAPPY: clears the session data' do
    @controller.end_session
    expect(@session[:trip]).must_be_nil
  end

  private

  def setup_trip_data
    @origin = '1001, Daxue Rd., East Dist., Hsinchu City 300093'
    @destination = '101-1, Sec. 2, Guangfu Rd., East Dist., Hsinchu City 300044'
    @strategy = 'walking'
  end

  def setup_session_controller
    @session = {}
    @controller = Leaf::SessionController.new(@session)
    @result = @controller.set_trip(@origin, @destination, @strategy)
  end
end
