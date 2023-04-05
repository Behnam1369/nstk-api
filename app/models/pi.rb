class Pi < ApplicationRecord
  has_many :pi_itms, foreign_key: 'IdPiItm'
  has_many :pi_prints, foreign_key: 'IdPi'
  belongs_to :delivery_term, class: dl, foreign_key: 'IdDeliveryTerm'

  self.table_name = 'Pi'
  self.primary_key = 'IdPi'
end
