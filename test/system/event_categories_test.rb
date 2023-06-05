require "application_system_test_case"

class EventCategoriesTest < ApplicationSystemTestCase
  setup do
    @event_category = event_categories(:one)
  end

  test "visiting the index" do
    visit event_categories_url
    assert_selector "h1", text: "Event categories"
  end

  test "should create event category" do
    visit event_categories_url
    click_on "New event category"

    click_on "Create Event category"

    assert_text "Event category was successfully created"
    click_on "Back"
  end

  test "should update Event category" do
    visit event_category_url(@event_category)
    click_on "Edit this event category", match: :first

    click_on "Update Event category"

    assert_text "Event category was successfully updated"
    click_on "Back"
  end

  test "should destroy Event category" do
    visit event_category_url(@event_category)
    click_on "Destroy this event category", match: :first

    assert_text "Event category was successfully destroyed"
  end
end
