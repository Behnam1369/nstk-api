class User < ApplicationRecord
  has_many :work_missioners, foreign_key: 'IdUser'
  has_many :roles, foreign_key: 'IdUser'

  self.table_name = 'Users'
  self.primary_key = 'IdUser'
end
