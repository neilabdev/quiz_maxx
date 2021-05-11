class Answer < ApplicationRecord
  belongs_to :submission
  belongs_to :problem
  validates :value, presence: true
end
