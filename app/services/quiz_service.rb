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

    def add_problem(name:nil,title:,description:nil, weight: 1.0, priority:1,&block)
      Problem.transaction do |transaction|
        self.service.add_problem(quiz: quiz,name:name,title:title,description: description, weight: weight, priority: priority) do |p|
          dsl.problem = p
          dsl.instance_eval(&block) if block_given?
        end

        problem
      end
    end

    def add_solution(value:,correct:true,priority:1,&block)
      Solution.transaction do |transaction|
        self.service.add_solution(problem: self.problem,value:value,correct:correct,priority:priority) do |s|
          dsl.instance_eval(&block) if block_given?
        end
      end
    end

    def add_answer(problem:, value:)
      p = problem.is_a?(String) ? quiz.problems.named(problem).first : problem
      a = service.add_answer(submission: submission,problem:p, value:value)
      a
    end

    def grade_submission(&block)
      Submission.transaction do |transaction|
        dsl.instance_eval(&block) if block_given?
        service.grade_submission(submission: submission)
      end
    end

  end

  def initialize(user=nil)
    @user = user
  end

  def build_quiz(user:nil,title:,description:nil,category:nil,active:true,&block)
    Quiz.transaction do |transaction|
      dsl = QuizDSL.new(quiz:add_quiz(user:user,title:title,description:description,active: active),service:self)
      dsl.instance_eval(&block)
      dsl
    end
  end

  def add_quiz(user:nil,title:,description:nil,active:true,&block)
    quiz = Quiz.new( user: user||@user, name:title,description: description,active:active)
    block.call(quiz) if block_given?
    quiz.save!
    quiz
  end

  def add_problem(quiz:, name:nil,title:,description:nil, weight: 1.0, priority:1,&block)
    problem = quiz.problems.build(name:name, title:title,description:description, weight: weight, priority:priority)
    block.call(problem) if block_given?
    problem.save!
    problem
  end

  def add_solution(problem:, value:,correct:true,priority:1)
    solution = problem.solutions.build(value: value,correct:correct,priority: priority)
    solution.save!
    solution
  end

  def add_answer(submission:,problem:nil,solution:nil,value:)
    p = problem || solution&.problem
    answer = Answer.new(problem: p,value: value)
    submission.answers << answer
    submission.save!
    answer
  end

  def grade_submission(submission:)
    quiz = submission.quiz
    solution = {}
    answer = {}
    correct_answers = 0
    invalid_answers = 0

    submission.answers.each do |a| # This helps prevent N+1 performance with single query.
      answer[a.problem_id] ||= []
      answer[a.problem_id] << a
    end

    quiz.solutions.correct.each do |s| # This helps prevent N+1 performance with single query.
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
    submission.completed_at = DateTime.now
    submission.save!
  end

  def list_quizzes
    Quiz.active.recent
  end

  def make_submission(quiz: )
    submission = Submission.new(user: @user, quiz: quiz)
    submission.save!
    submission
  end

  def build_submission(quiz:nil, submission:, &block)
    Submission.transaction do |transaction|
      s = submission || make_submission(quiz: quiz)
      dsl = QuizDSL.new(submission:s,service:self)
      dsl.instance_eval(&block) if block_given?
      dsl
    end
  end

  def test_syntax
    build_quiz(title:"foo") do |q|
      add_problem(name:"revolution1",title: "Year of the revolution") do |p|
        add_solution(value:"1776",correct:true)
      end
      # add_problem()
    end

    build_submission(quiz:quiz) do
      add_answer(problem:"name",value: "24")
      add_answer(problem:"name",value: "24")

    end
  end

end