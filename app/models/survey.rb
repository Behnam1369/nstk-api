class Survey < ApplicationRecord
  belongs_to :user, foreign_key: 'IdUser'
  has_many :survey_questions, foreign_key: 'IdSurvey', inverse_of: :survey, dependent: :destroy
  accepts_nested_attributes_for :survey_questions

  self.table_name = 'Survey'
  self.primary_key = 'IdSurvey'
end
