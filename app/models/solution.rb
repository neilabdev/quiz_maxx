class Solution < ApplicationRecord
  belongs_to :problem
  validates :value, presence: true
end
