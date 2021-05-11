class Problem < ApplicationRecord
  has_many :solutions, dependent: :delete_all do
    def correct
      where(correct:true)
    end
  end
  has_many :quiz_problems
  has_many :quizzes, through: :quiz_problems

  validates :title, presence: true
  #  validates :solutions, :length => { :minimum => 1 }
  validates :name, :on=>:create,
            :allow_nil=>true,
            :format => { :with => /[0-9a-zA-Z_]/ }, :if => Proc.new{|f| f.title.present? }
  def named(*names)
    where("name in (?)",names)
  end
  accepts_nested_attributes_for :solutions , :quizzes, allow_destroy: true #,:solutions_attributes

  before_validation  do
    self.name = generate_slug(self.title) unless self.name.present?
    self.priority = 1 unless self.priority.present?
  end

  private

  def generate_slug(title)
    title_slug = title.to_s.strip.downcase.gsub(/[^a-zA-Z0-9]/, "_")
  end
end
