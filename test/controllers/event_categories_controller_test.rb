require "test_helper"

class EventCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event_category = event_categories(:one)
  end

  test "should get index" do
    get event_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_event_category_url
    assert_response :success
  end

  test "should create event_category" do
    assert_difference("EventCategory.count") do
      post event_categories_url, params: { event_category: {  } }
    end

    assert_redirected_to event_category_url(EventCategory.last)
  end

  test "should show event_category" do
    get event_category_url(@event_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_category_url(@event_category)
    assert_response :success
  end

  test "should update event_category" do
    patch event_category_url(@event_category), params: { event_category: {  } }
    assert_redirected_to event_category_url(@event_category)
  end

  test "should destroy event_category" do
    assert_difference("EventCategory.count", -1) do
      delete event_category_url(@event_category)
    end

    assert_redirected_to event_categories_url
  end
end
