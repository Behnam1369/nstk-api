class WorkMissioner < ApplicationRecord
  belongs_to :user, foreign_key: 'IdUser'
  belongs_to :work_mission, foreign_key: 'IdWorkMission'
  has_many :work_mission_reports, foreign_key: 'IdWorkMissioner'
  accepts_nested_attributes_for :work_mission_reports
  has_many :work_mission_achievements, foreign_key: 'IdWorkMissioner'
  accepts_nested_attributes_for :work_mission_achievements

  self.table_name = 'WorkMissioner'
  self.primary_key = 'IdWorkMissioner'
end
