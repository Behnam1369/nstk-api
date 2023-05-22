class Dept < ApplicationRecord
  belongs_to :dl, foreign_key: 'IdDl'
  
  self.table_name = 'Dl_Dept'
  self.primary_key = 'IdDl'

  def manager
    Role.find(self[:IdManager]).user
  end
end
