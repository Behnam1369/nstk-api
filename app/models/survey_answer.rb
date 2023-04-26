class SurveyAnswer < ApplicationRecord
  belongs_to :user, foreign_key: 'IdUser'
  belongs_to :survey_question_option, foreign_key: 'IdSurveyQuestionOption'
  belongs_to :survey_question, foreign_key: 'IdSurveyQuestion'
  
  self.table_name = 'SurveyAnswer'
  self.primary_key = 'IdSurveyAnswer'
end
