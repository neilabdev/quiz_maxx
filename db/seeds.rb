

admin_user = User.create!(email: 'admin@neilab.com', role: User::Role::ADMIN, password: 'password', password_confirmation: 'password')
student_user = User.create!(email: 'studen@neilab.com', role: User::Role::STUDENT, password: 'password', password_confirmation: 'password')

quiz_service = QuizService.new(admin_user)
quiz_service.build_quiz(name: "american_history", title: "American History",
   description:"Test your history skill and knowledge of the American Revolution!", category: "History") do
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

quiz_service.build_quiz(name: "math", title: "Math",
                        description:"Have simple math skills? Test your knowledge  as simple as 1, 2, 3.", category: "Math") do
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