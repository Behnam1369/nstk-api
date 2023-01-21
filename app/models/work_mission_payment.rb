class WorkMissionPayment < ApplicationRecord
  belongs_to :user, foreign_key: 'IdWorkMissioner'
  belongs_to :work_mission, foreign_key: 'IdWorkMission'

  self.table_name = 'WorkMissionPayment'
  self.primary_key = 'IdWorkMissionPayment'
end
