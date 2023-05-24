class UserGroupMember < ApplicationRecord
  belongs_to :user, foreign_key: :IdUser
  belongs_to :user_group, foreign_key: :IdGroup

  self.table_name = 'UserGroupMembers'
end
