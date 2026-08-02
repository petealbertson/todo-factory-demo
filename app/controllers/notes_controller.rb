class NotesController < ApplicationController
  def create
    @todo = Todo.find(params.expect(:todo_id))
    @note = @todo.notes.build(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to @todo, notice: "Note was successfully added." }
        format.json { render json: @note, status: :created, location: todo_url(@todo) }
      else
        format.html { redirect_to @todo, status: :see_other, alert: "Note could not be saved." }
        format.json { render json: @note.errors, status: :unprocessable_content }
      end
    end
  end

  private
    def note_params
      params.expect(note: [ :body ])
    end
end
