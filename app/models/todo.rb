class Todo < ApplicationRecord
  has_many :tags, dependent: :destroy

  enum :priority, { low: "low", medium: "medium", high: "high" }, default: :medium

  scope :ordered, -> {
    order(
      Arel.sql("due_date ASC NULLS LAST"),
      Arel.sql("CASE priority WHEN 'high' THEN 0 WHEN 'medium' THEN 1 WHEN 'low' THEN 2 ELSE 3 END"),
      created_at: :desc
    )
  }

  def overdue?
    due_date.present? && !completed? && due_date < Date.current
  end

  # Comma-separated tag names, used by the todo form.
  def tag_names
    @tag_names || tags.map(&:name).join(", ")
  end

  def tag_names=(value)
    @tag_names = value
  end

  after_save :apply_tag_names

  private

  def apply_tag_names
    return unless @tag_names

    names = @tag_names.to_s.split(",").map(&:strip).reject(&:blank?)
    tags.where.not(name: names).destroy_all
    names.each { |name| tags.create!(name: name) unless tags.exists?(name: name) }
    @tag_names = nil
  end
end
