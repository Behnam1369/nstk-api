class LoanType < ApplicationRecord
  has_many :loans, foreign_key: 'IdLoanType'

  self.table_name = 'LoanType'
  self.primary_key = 'IdLoanType'
end
