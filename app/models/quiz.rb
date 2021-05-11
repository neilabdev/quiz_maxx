class Quiz < ApplicationRecord
  belongs_to :user
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

  before_validation  do
    self.name = generate_slug(self.title) unless self.name.present?
  end

  scope :active, ->() {
    where(active: true)
  }
  scope :inactive, ->() {
    where(active:false)
  }

  scope :named, ->(*names) {
    where("name in (?)",names)
  }
  scope :recent, ->(column_name="created_at") {order(column_name => :desc)}

  def headline
    self.title || self.name
  end

  private
  def generate_slug(title)
    title_slug = title.to_s.strip.downcase.gsub(/[^a-zA-Z0-9]/, "_")
  end
end
