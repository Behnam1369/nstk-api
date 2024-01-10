class EmployeeEvaluationSubmission < ApplicationRecord
  belongs_to :user, foreign_key: 'IdUser'
  belongs_to :manager, foreign_key: 'IdManager', class_name: 'User'
  has_many :employee_evaluation_scores, foreign_key: 'IdEmployeeEvaluationSubmission', dependent: :destroy

  self.table_name = 'EmployeeEvaluationSubmission'
  self.primary_key = 'IdEmployeeEvaluationSubmission'
end
