class SurveyController < ApplicationController
  def index 
    sql = " 
      declare @iduser int = ?
      select 
        *
      from survey where 
      (
        @iduser in (select substr from dbo.split(',', Participants)) or 
        @iduser in (select iduser from UserGroupMembers where IdGroup in (select substr from dbo.split(',', Participants)))
      ) and (
        @iduser not in (select substr from dbo.split(',', Exclude)) or 
        @iduser not in (select iduser from UserGroupMembers where IdGroup in (select substr from dbo.split(',', Exclude)))
      )
      and getdate() > starttime
    "

    data = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql([sql, params[:iduser]])
    )

    render json: { message: 'Success', data:  }
  end

  def show
    sql = "
    declare @iduser int = ?
    declare @idsurvey int = ?
    select cast((select
      *,
      (
        select 
          *, 
          (
            select 
              * ,
              (
                case when exists(
                  select * from SurveyAnswer 
                  where 
                    IdSurveyQuestion = SurveyQuestion.IdSurveyQuestion and 
                    IdSurveyQuestionOption = SurveyQuestionOption.IdSurveyQuestionOption and 
                    iduser = @iduser
                ) then 'true' else 'false' end
              ) as Selected 
            from SurveyQuestionOption
            where IdSurveyQuestion = SurveyQuestion.IdSurveyQuestion
            for json path, include_null_values
          ) as survey_question_options
        from SurveyQuestion where IdSurvey = @idsurvey
        for json path, include_null_values
      ) as survey_questions
    from survey where IdSurvey = @idsurvey 
    for json path, include_null_values, without_array_wrapper) as nvarchar(max)) as data
    "
    
    data = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql([sql, params[:iduser], params[:idsurvey]])
    )

    render json: { message: 'Success', data:  }
  end

  def result
    sql = " 
    declare @iduser int = ?
    declare @idsurvey int = ?

      select  
        a.IdSurveyQuestion,
        a.IdSurvey,
        a.Title,
        (
          select 
            x.IdSurveyQuestionOption, 
            x.Title , 
            case when y.IdSurveyAnswer is null then 'Selected' else 'NotSelected' end as Status, 
            (select count(*) from SurveyAnswer where IdSurveyQuestion = x.IdSurveyQuestion and IdSurveyQuestionOption = x.IdSurveyQuestionOption) as Voted, 
            (select count(*) from SurveyAnswer where IdSurveyQuestion = x.IdSurveyQuestion) as TotalVotes
          from SurveyQuestionOption as x 
          left join SurveyAnswer as y on 
            x.IdSurveyQuestion = y.IdSurveyQuestion and 
            x.IdSurveyQuestionOption = y.IdSurveyQuestion and 
            y.IdUser = @iduser
          where x.IdSurveyQuestion = a.IdSurveyQuestion
          for json path, include_null_values
        ) as Options
      from SurveyQuestion as a where a.IdSurvey = @idsurvey

    "

    data = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql([sql, params[:iduser], params[:idsurvey]])
    )

    render json: { message: 'Success', data:  }
  end
  
  def create
    survey = Survey.create(survey_params)
    survey.user = User.find(params[:iduser])
    if survey.save
      render json: { message: 'Success', data: survey.as_json(include: { survey_questions: { include: :survey_question_options } }) }
    else
      render json: { message: 'Failed', data: survey.errors }
    end
  end

  def update
    survey = Survey.find(params[:idsurvey])
    survey_questions = survey.survey_questions
    
    #return if survay has answer
    if SurveyAnswer.where(sur).count > 0
      render json: { message: 'Failed', data: 'Survey has been answered' }
      return
    end

    survey_questions.for_each do |survey_question|
      survey_question.survey_question_options.destroy_all
      survey_question.destroy
    end
    

    if survey.update(survey_params)
      render json: { message: 'Success', data: survey.as_json(include: { survey_questions: { include: :survey_question_options } }) }
    else
      render json: { message: 'Failed', data: survey.errors }
    end
  end

  def destroy
    survey = Survey.find(params[:idsurvey])
    if survey.destroy
      render json: { message: 'Success', data: survey.as_json(include: { survey_questions: { include: :survey_question_options } }) }
    else
      render json: { message: 'Failed', data: survey.errors }
    end
  end

  def vote 
    answers = params[:answers]

    # delete existing answers of current user for this survey
    user = User.find(params[:iduser])
    survey = Survey.find(params[:idsurvey])
    survey_questions = survey.survey_questions
    SurveyAnswer.where(IdUser: user.id, IdSurveyQuestion: survey_questions.map(&:id)).destroy_all    
    
    answers.each do |answer|
      sa = SurveyAnswer.new(
        IdUser: params[:iduser],
        IdSurveyQuestion: answer[:idsurveyquestion],
        IdSurveyQuestionOption: answer[:idsurveyquestionoption],
        AnswerTime: Time.now
      )
      if sa.save
        puts 'created successfully'
      else
        puts sa.errors.inspect
      end
    end
    render json: { message: 'Success' }
  end

  
  private 
  def survey_params
    params.require(:survey).permit(
      :Title,  
      :Participants,
      :Exclude,
      :Users,
      :UsersCount, 
      :StartTime,
      :EndTime,
      survey_questions_attributes: [
        :Title,
        survey_question_options_attributes: [
          :Title,
        ]
      ]      
    )
  end

end