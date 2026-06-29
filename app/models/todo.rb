class Todo < ApplicationRecord
  def overdue?
    due_on.present? && !completed? && due_on < Date.current
  end
end
