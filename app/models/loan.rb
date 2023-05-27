class Loan < ApplicationRecord
  belongs_to :user, foreign_key: 'IdUser'
  # belongs_to :loan_types, foreign_key: 'IdLoanType'

  self.table_name = 'Loan'
  self.primary_key = 'IdLoan'
end
