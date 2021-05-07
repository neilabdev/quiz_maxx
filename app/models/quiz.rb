class Quiz < ApplicationRecord
  has_many :quiz_problems
  has_many :problems, through: :quiz_problems
  has_many :solutions, through: :problems
  validates :name, presence: true

end
