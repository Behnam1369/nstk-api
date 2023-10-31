class Ride < ApplicationRecord
  belongs_to :dept, foreign_key: :IdDept
  belongs_to :user, foreign_key: :IdUser

  self.table_name = 'Ride'
  self.primary_key = 'IdRide'
end
