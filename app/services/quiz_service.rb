class QuizService
  # @return [User]
  attr_accessor :user

  class QuizDSL
    # @return [Quiz]
    attr_accessor :quiz

    # @return [Problem]
    attr_accessor :problem

    # @return [User]
    attr_accessor :user

    # @return [QuizService]
    attr_accessor :service

    # @return [QuizDSL]
    attr_accessor :dsl

    # @return [Submission]
    attr_accessor :submission


    def initialize(quiz:nil,service:nil,submission:nil)
      @submission = submission
      @service = service
      @quiz = quiz || submission&.quiz
      @dsl = self
    end

    def add_problem(title:,description:nil, weight: 1.0, priority:1,&block)
      self.service.add_problem(quiz: self.quiz,title:title,description: description,
                               weight: weight, priority: priority) do |p|
        dsl.problem = p
        dsl.instance_eval(&block) if block_given?
      end

      problem
    end

    def add_solution(value:,correct:true,priority:1,&block)
      self.service.add_solution(problem: self.problem,value:value,correct:correct,priority:priority) do |s|
        dsl.instance_eval(&block) if block_given?
      end
    end

    def add_answer(problem:, value:)

    end

  end

  def initialize(user=nil)
    @user = user
  end

  def build_quiz(user:nil,title:,description:nil,active:true,&block)
    dsl = QuizDSL.new(quiz:add_quiz(user:user,title:title,description:description,active: active),service:self)
    dsl.instance_eval(&block)
    dsl
  end

  def add_quiz(user:nil,title:,description:nil,active:true,&block)
    quiz = Quiz.new( user: user||@user, title:title,description: description,active:active)
    block.call(quiz) if block_given?
    quiz
  end

  def add_problem(quiz:, title:,description:nil, weight: 1.0, priority:1,&block)
    problem = Problem.new(quiz:quiz,title:title,description:description, weight: weight, priority:priority)
    block.call(problem) if block_given?
    problem
  end

  def add_solution(problem:, value:,correct:true,priority:1)
    solution = Solution.new(problem: problem,value: value,correct:correct,priority: priority)
    solution
  end

  def add_answer(submission:,problem:nil,solution:nil,value:)
    p = problem || solution&.problem
    answer = Answer.new(problem: p,value: value)
    submission.answers << answer
    answer
  end

  def grade_submission(submission:)
    quiz = submission.quiz
    solution = {}
    answer = {}
    correct_answers = 0
    invalid_answers = 0

    submission.answers.each do |a| # This helps prevent N+1 performance.
      answer[a.problem_id] ||= []
      answer[a.problem_id] << a
    end

    quiz.solutions.correct.each do |s| # This helps prevent N+1 performance.
      answer[s.problem_id] ||=[]
      solution[s.problem_id] ||=[]
      solution[s.problem_id] << s
    end

    solution.keys.each do |problem_id|
      solution_values = solution[problem_id].collect {|r| r.value.to_s.downcase }.sort
      answer_values = answer[problem_id].collect {|r| r.value.to_s.downcase }.sort
      if solution_values == answer_values then
        correct_answers = correct_answers + 1
      else
        invalid_answers = invalid_answers + 1
      end
    end

    total_questions = solution.keys.size

    submission.total_wrong = invalid_answers
    submission.total_correct = correct_answers
    submission.total_problems = total_questions
    submission.score = correct_answers / [total_questions.to_f,1].max
    #solution.keys.each do |problem_id|
    #values = solution[problem_id].collect {|r| r.value} # ["valu1","value2"]
    # end

    #quiz.problems.each_with_index do |p,i|
      # solutions = p.solutions.correct.pluck(:value)
      #end
    submission.completed_at = DateTime.now
    submission.save!
  end

  def list_quizzes
    Quiz.active.recent
  end

  def build_submission(quiz: )
    submission = Submission.new(user: @user, quiz: quiz)
    submission.save!
    submission
  end

  def build_grade_submission(submission:,&block)
    Submission.transaction do |transaction|
      dsl = QuizDSL.new(submission:submission,service:self)
      dsl.instance_eval(&block) if block_given?
      dsl
    end
  end

  def test_syntax
    build_quiz(title:"foo") do |q|
      add_problem(title: "Year of the revolution") do |p|
        add_solution(value:"1776",correct:true)
      end
      # add_problem()
    end
  end

end