class EmployeeEvaluationController < ApplicationController
  include ShamsiDateHelper

  def index
    user = User.find(params[:iduser])
    employee_evaluations = EmployeeEvaluation.all.includes(:employee_evaluation_users)
    
    result = []

    employee_evaluations.each do |evaluation|
      related_users = evaluation.related_users(user)
      evaluation_with_users = {
        employee_evaluation: evaluation,
        related_users: related_users
      }
      result << evaluation_with_users
    end
    
    render json: result
  end

  def show 
    q = "
    declare @idemployeeevaluationuser int = ?
    select 
      b.IdEmployeeEvaluation,
      b.IdUser,
      c.*,
      d.Score as Manager0, 
      e.Score as Manager,
      b.IdManager0,
      b.IdManager,
      b.ManagerSubmitDate, 
      b.ManagerSubmitDate0,
      f.Fname, 
      f.Lname,
      a.RatingStartDate
    from EmployeeEvaluation as a
    inner join EmployeeEvaluationUser as b on a.IdEmployeeEvaluation = b.IdEmployeeEvaluation
    inner join EmployeeEvaluationQuestion as c on b.IdQuestionGroup = c.IdQuestionGroup
    left join EmployeeEvaluationScore as d on 
      d.IdUser = b.IdUser and 
      d.IdManager = b.IdManager0 and 
      d.IdEmployeeEvaluation = b.IdEmployeeEvaluation and 
      d.IdQuestion = c.IdEmpolyeeEvaluationQuestion
    left join EmployeeEvaluationScore as e on 
      e.IdUser = b.IdUser and 
      e.IdManager = b.IdManager and 
      e.IdEmployeeEvaluation = b.IdEmployeeEvaluation and 
      e.IdQuestion = c.IdEmpolyeeEvaluationQuestion
    left join users as f on f.iduser = b.IdUser

    where b.IdEmployeeEvaluationUser = @idemployeeevaluationuser
    and c.Active = 1
    "

    data = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql([q, params[:idemployeeevaluationuser]])
    )

    render json: data
  end

  def save 
    evaluation_user = EmployeeEvaluationUser.find(params[:idemployeeevaluationuser])
    arr = params[:questions]
    arr.each { |item| 
      question = EmployeeEvaluationQuestion.find(item[:IdEmpolyeeEvaluationQuestion])
      evaluation_score = EmployeeEvaluationScore.where(
        IdUser: item[:IdUser],
        IdManager: params[:iduser],
        IdQuestion: question.IdEmpolyeeEvaluationQuestion,
      ).first_or_initialize
      
      evaluation_score.IdEmployeeEvaluation = evaluation_user.IdEmployeeEvaluation
      evaluation_score.Score = (
        params[:iduser].to_i == item[:IdManager].to_i && !item[:Manager].nil? ? 
        item[:Manager] : 
        item[:Manager0])
      evaluation_score.save
    }

    if params[:iduser].to_i == evaluation_user.IdManager0
      evaluation_user.ManagerSubmitDate0 = DateTime.now
      evaluation_user.ManagerSubmitDateShamsi0 = shamsi_date(DateTime.now)
    else
      evaluation_user.ManagerSubmitDate = DateTime.now
      evaluation_user.ManagerSubmitDateShamsi = shamsi_date(DateTime.now)
    end

    evaluation_user.save
  end
end