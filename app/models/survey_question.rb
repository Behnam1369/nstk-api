class SurveyQuestion < ApplicationRecord
  belongs_to :survey, foreign_key: 'IdSurvey', inverse_of: :survey_questions
  has_many :survey_question_options, foreign_key: 'IdSurveyQuestion', inverse_of: :survey_question, dependent: :destroy
  accepts_nested_attributes_for :survey_question_options

  self.table_name = 'SurveyQuestion'
  self.primary_key = 'IdSurveyQuestion'
end
