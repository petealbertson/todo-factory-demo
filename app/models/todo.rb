class Todo < ApplicationRecord
  enum :priority, { low: "low", medium: "medium", high: "high" }, default: :medium

  scope :ordered, -> {
    order(
      Arel.sql("CASE priority WHEN 'high' THEN 0 WHEN 'medium' THEN 1 WHEN 'low' THEN 2 ELSE 3 END"),
      created_at: :desc
    )
  }

  def overdue?
    due_on.present? && !completed? && due_on < Date.current
  end
end
