class Problem < ApplicationRecord
  has_many :solutions, dependent: :delete_all
  has_many :quiz_problems
  has_many :quizzes, through: :quiz_problems
  validates :title, presence: true
  validates :solutions, :length => { :minimum => 1 }
  accepts_nested_attributes_for :solutions , allow_destroy: true #,:solutions_attributes
end
