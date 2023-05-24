class Role < ApplicationRecord
  belongs_to :dept, foreign_key: :IdDept
  belongs_to :user, foreign_key: :IdUser

  self.table_name = 'Role'
  self.primary_key = 'IdRole'
end
