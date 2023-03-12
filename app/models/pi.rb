class Pi < ApplicationRecord
    has_many :pi_itms, foreign_key: 'IdPiItm'
    belongs_to :delivery_term, class: dl, foreign_key: 

    self.table_name = 'Pi'
    self.primary_key = 'IdPi'
end
