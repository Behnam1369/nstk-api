class EmploymentLetter < ApplicationRecord
  belongs_to :user, foreign_key: 'IdUser'
  # belongs_to :loan_types, foreign_key: 'IdLoanType'

  self.table_name = 'EmploymentLetter'
  self.primary_key = 'IdEmploymentLetter'
end
