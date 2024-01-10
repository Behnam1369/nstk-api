class EmployeeEvaluationController < ApplicationController
  include ShamsiDateHelper

  def index
    data = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql("Exec LoadEvaluationQuarters #{params[:iduser]}")
    )

    render json: data
  end

  def show 
    data = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql("Exec LoadEvaluation #{params[:id_employee]}, #{params[:quarter]}")
    )

    parsed_data = JSON.parse(data.first[''])

    render json: parsed_data
  end

  def save 
    ees = EmployeeEvaluationSubmission.new(
      IdManager: params[:iduser], 
      IdUser: params[:id_employee], 
      Quarter: params[:quarter], 
      SubmitDate: DateTime.now,
      SubmitDateShamsi: shamsi_date(DateTime.now)
    )
    puts ees
    if ees.save
      puts 'saved'
      arr = params[:questions]
      arr.each { |item| 
        score = EmployeeEvaluationScore.new(
          IdQuestion: item[:IdQuestion],
          IdUser: params[:id_employee],
          Score: item[:Score],
          IdEmployeeEvaluationSubmission: ees.IdEmployeeEvaluationSubmission
        )

        if score.save
          puts 'score saved'
        else
          puts score.errors.full_messages
        end
      }
    else
      puts ees.errors.full_messages
    end
  end
end