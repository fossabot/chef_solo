require 'test_helper'

class JobControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get job_create_url
    assert_response :success
  end

  test "should get list" do
    get job_list_url
    assert_response :success
  end

  test "should get check" do
    get job_check_url
    assert_response :success
  end

end
