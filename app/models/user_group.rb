class UserGroup < ApplicationRecord
  has_many :user_group_members, foreign_key: :IdGroup
  has_many :users, through: :user_group_members

  self.table_name = 'UserGroups'
  self.primary_key = 'IdUserGroup'
end
