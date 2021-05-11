require 'rails_helper'

describe QuizService, type: :model do
  let(:admin_user) { create(:admin_user) }
  let(:student_user) { create(:student_user) }
  let(:quiz_service) { QuizService.new(admin_user.reload) }
  let(:student_service) { QuizService.new(admin_user.reload) }

  context "creating test" do
    before(:each) do
      quiz_service.build_quiz(name: "american_history", title: "American History", category: "History") do
        add_problem(name: "revolution1", title: "Year of the revolution") do
          add_solution(value: "1776", correct: true)
          add_solution(value: "1984", correct: false)
          add_solution(value: "2001", correct: false)
          add_solution(value: "1787", correct: false)
        end

        add_problem(name: "firstpresident", title: "The First President of the United States?") do
          add_solution(value: "Alexander Hamilton", correct: true)
          add_solution(value: "George Washington", correct: false)
          add_solution(value: "Barack Obama", correct: false)
          add_solution(value: "Hillary Clinton", correct: false)
        end

        add_problem(name: "succession", title: "The United States seceded from which country?") do
          add_solution(value: "United Kingdom", correct: false)
          add_solution(value: "Canada", correct: false)
          add_solution(value: "Great Britain", correct: true)
          add_solution(value: "Ireland", correct: false)
        end

        add_problem(name: "prohibition", title: "What Amendment prohibited Alcohol?") do
          add_solution(value: "12", correct: false)
          add_solution(value: "18", correct: true)
          add_solution(value: "21", correct: false)
          add_solution(value: "1", correct: false)
        end
      end

      quiz_service.build_quiz(name: "math", title: "Math", category: "Math") do
        add_problem(name: "pie", title: "Which number best represents pie?") do
          add_solution(value: "3.14", correct: true)
          add_solution(value: "42", correct: false)
          add_solution(value: "3.33", correct: false)
          add_solution(value: "1.61", correct: false)
        end

        add_problem(name: "parallelogram", title: "How many sides does a parallelogram have?") do
          add_solution(value: "8", correct: false)
          add_solution(value: "4", correct: true)
          add_solution(value: "16", correct: false)
          add_solution(value: "32", correct: false)
        end

        add_problem(name: "even", title: "Which numbers are even?") do
          add_solution(value: "2", correct: true)
          add_solution(value: "5", correct: false)
          add_solution(value: "4", correct: true)
          add_solution(value: "11", correct: false)
        end

      end
    end

    it "it should expect two test" do
      expect(Quiz.count).to eq 2
      expect(Problem.count).to eq 7
    end

    it "it should grade test with two answers" do
      exam = student_service.build_submission(quiz: "math") do
        add_answer(problem: "even", value: "2")
        add_answer(problem: "even", value: "4")
        add_answer(problem: "parallelogram", value: "4")
        add_answer(problem: "pie", value: "3.14")
        grade_submission
      end
      expect(exam.score).to eq 1.0

    end

    it "it should grade test getting one answer wrong" do
      exam = student_service.build_submission(quiz: "american_history") do
        add_answer(problem: "revolution1", value: "1776")
        add_answer(problem: "firstpresident", value: "Barack Obama")
        add_answer(problem: "succession", value: "Great Britain")
        add_answer(problem: "prohibition", value: "18")
        grade_submission
      end

      expect(exam.score).to eq 0.75
    end
  end
end