class Task < ApplicationRecord
  validates :title, presence: true
  
  after_initialize :set_defaults, if: :new_record?
  
  private
  
  def set_defaults
    self.completed ||= false
  end
end
