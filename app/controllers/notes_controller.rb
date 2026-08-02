class NotesController < ApplicationController
  # POST /todos/:todo_id/notes
  def create
    @todo = Todo.find(params.expect(:todo_id))
    note = @todo.notes.build(note_params)

    if note.save
      redirect_to @todo, notice: "Note was successfully added."
    else
      redirect_to @todo, alert: "Note could not be added."
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def note_params
      params.expect(note: [ :body ])
    end
end
