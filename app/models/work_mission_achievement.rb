class WorkMissionAchievement < ApplicationRecord
  belongs_to :work_missioner, foreign_key: 'IdWorkMissioner'
  belongs_to :work_mission, foreign_key: 'IdWorkMission'

  self.table_name = 'WorkMissionAchievement'
  self.primary_key = 'IdWorkMissionAchievement'
end
