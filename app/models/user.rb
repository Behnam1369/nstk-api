class User < ApplicationRecord
  has_many :work_missioners, foreign_key: 'IdUser'
  has_many :roles, foreign_key: 'IdUser'
  has_many :user_group_members, foreign_key: :IdUser
  has_many :user_groups, through: :user_group_members

  self.table_name = 'Users'
  self.primary_key = 'IdUser'

  def full_name
    "#{self.Fname} #{self.Lname}"
  end

  def dept
    roles.first.dept
  end
end
