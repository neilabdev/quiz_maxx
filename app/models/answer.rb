class Answer < ApplicationRecord
  belongs_to :submission
  validates :value, presence: true
end
