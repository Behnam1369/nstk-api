class WorkMissionReport < ApplicationRecord
  belongs_to :work_missioner, foreign_key: 'IdWorkMissioner'
  belongs_to :work_mission, foreign_key: 'IdWorkMission'

  self.table_name = 'WorkMissionReport'
  self.primary_key = 'IdWorkMissionReport'
end
