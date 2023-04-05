class PiItm < ApplicationRecord
  belongs_to :pi, foreign_key: 'IdPi'

  self.table_name = 'PiItm'
  self.primary_key = 'IdPiItm'
end
