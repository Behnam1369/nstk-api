class Pr < ApplicationRecord
  has_many :work_missioners, foreign_key: 'IdUser'

  self.table_name = 'Pr'
  self.primary_key = 'IdPr'
end
