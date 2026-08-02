require "test_helper"

# Benchmark acceptance test for task-02-notes-association.
# Copy to test/integration/todo_notes_test.rb and implement the feature
# so this test passes. Do NOT modify this file.
class TodoNotesTest < ActionDispatch::IntegrationTest
  setup do
    Todo.delete_all
    Note.delete_all
    @todo = Todo.create!(title: "Plan the trip")
  end

  test "a note can be added to a todo and is shown on its page" do
    post todo_notes_url(@todo), params: { note: { body: "Book the hotel" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_match "Book the hotel", response.body
  end

  test "a todo lists its notes on the show page" do
    @todo.notes.create!(body: "Pick dates")
    @todo.notes.create!(body: "Invite guests")
    get todo_url(@todo)
    assert_response :success
    assert_select "div[id^='note_']", count: 2
  end

  test "a note with a blank body is not saved" do
    post todo_notes_url(@todo), params: { note: { body: "" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "div[id^='note_']", count: 0
  end
end
