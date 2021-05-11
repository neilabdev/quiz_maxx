class QuizProblem < ApplicationRecord
  belongs_to :problem
  belongs_to :quiz
end
