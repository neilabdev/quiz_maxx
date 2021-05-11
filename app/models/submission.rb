class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
  has_many :answers
  #validates :answers  , presence: true,  length: { :minimum => 1 },:if => lambda{ |object| object.completed_at.present? }
end
