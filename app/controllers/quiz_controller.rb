class QuizController < ApplicationController

  def index
    @quizzes = quiz_service.list_quizzes
  end

  def create
    return
  end

  def start
    quiz = Quiz.find(params[:id])
    submission = quiz_service.make_submission(quiz: quiz)
    redirect_to quiz_path(submission)
  end

  def score
    @submission = current_user.submissions.find(params[:id])

  end

  def finish
    submission = current_user.submissions.find(params[:id])
    choice = params[:submission][:answers][:choice]
    problems =
      Problem.where("id IN (?)",params[:submission][:answers][:choice].keys).collect {|p| [p.id,p]}.to_h

    choice.each_pair do |problem_id,choices|
      active_choices = choices.select {|k,v| v == "1"}.keys
      active_choices.each do |val|
        quiz_service.add_answer(submission:submission,problem: problems[problem_id.to_i],value:val)
      end
    end

    quiz_service.grade_submission(submission:submission)

    redirect_to score_quiz_path(submission)
  end

  def show
    @submission = Submission.find(params[:id])
    @quiz = @submission&.quiz
  end

  private

  def quiz_service
    @quiz_server ||= QuizService.new(current_user)
  end

end
