class Quiz < ApplicationRecord
  has_many :quiz_problems
  has_many :problems, through: :quiz_problems do
    def named(*names)
      where("name in (?)",names)
    end
  end
  has_many :solutions, through: :problems do
    def correct
      where("#{Solution.table_name}.correct = ?",true)
    end
  end
  validates :name, presence: true
  belongs_to :user

  scope :active, ->() {
    where(active: true)
  }
  scope :inactive, ->() {
    where(active:false)
  }
  scope :recent, ->(column_name="created_at") {order(column_name => :desc)}

end
