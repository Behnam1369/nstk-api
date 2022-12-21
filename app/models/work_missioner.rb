class WorkMissioner < ApplicationRecord
  belongs_to :user, foreign_key: 'IdUser'
  belongs_to :work_mission, foreign_key: 'IdWorkMission'

  self.table_name = 'WorkMissioner'
  self.primary_key = 'IdWorkMissioner'
end
