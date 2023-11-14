class EmployeeEvaluationScore < ApplicationRecord
  belongs_to :employee_evaluation, foreign_key: 'IdEmployeeEvaluation'
  belongs_to :employee_evaluation_question, foreign_key: 'IdQuestion'
  belongs_to :user, foreign_key: 'IdUser'
  belongs_to :manager, foreign_key: 'IdManager', class_name: 'User'

  self.table_name = 'EmployeeEvaluationScore'
  self.primary_key = 'IdEmployeeEvaluationScore'
end
