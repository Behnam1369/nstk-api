class EmployeeEvaluationUser < ApplicationRecord
  belongs_to :employee_evaluation, foreign_key: 'IdEmployeeEvaluation'
  belongs_to :user, foreign_key: 'IdUser'

  self.table_name = 'EmployeeEvaluationUser'
  self.primary_key = 'IdEmployeeEvaluationUser'
end
