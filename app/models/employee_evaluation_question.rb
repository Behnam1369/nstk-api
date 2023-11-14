class EmployeeEvaluationQuestion < ApplicationRecord
  belongs_to :employee_evaluation, foreign_key: 'IdEmployeeEvaluation'

  self.table_name = 'EmployeeEvaluationQuestion'
  self.primary_key = 'IdEmpolyeeEvaluationQuestion'
end
