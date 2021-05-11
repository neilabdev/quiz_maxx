class User < ApplicationRecord
  module Role
    STUDENT="student"
    ADMIN="admin"
    TEACHER="teacher"
    ALL=[STUDENT,ADMIN,TEACHER]
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :submissions

  def quiz_service
    @quiz_service ||= QuizService.new(self)
  end

  def is_admin?
    self.role == Role::ADMIN
  end

  def has_admin_access?
  is_admin? || self.role == Role::TEACHER
  end
end
