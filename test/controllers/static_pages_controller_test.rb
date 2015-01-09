require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Home | RoR IoT Tutorial"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | RoR IoT Tutorial"
  end

end
