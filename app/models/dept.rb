class Dept < ApplicationRecord
  belongs_to :dl, foreign_key: 'IdDl'

  self.table_name = 'Dl_Dept'
  self.primary_key = 'IdDl'
end
