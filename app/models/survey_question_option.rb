class SurveyQuestionOption < ApplicationRecord
  belongs_to :survey_question, foreign_key: 'IdSurveyQuestion', inverse_of: :survey_question_options

  self.table_name = 'SurveyQuestionOption'
  self.primary_key = 'IdSurveyQuestionOption'
end
