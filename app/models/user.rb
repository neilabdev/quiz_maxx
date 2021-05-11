class User < ApplicationRecord
  module Role
    STUDENT="student"
    ADMIN="admin"
    TEACHER="teacher"
    ALL=[STUDENT,ADMIN,TEACHER]
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  has_many :submissions

  def quiz_service
    @quiz_service ||= QuizService.new(self)
  end
end
