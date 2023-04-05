class PiPrintItm < ApplicationRecord
  belongs_to :pi_print, foreign_key: 'IdPiPrint', optional: true

  self.table_name = 'PiPrintItm'
  self.primary_key = 'IdPiPrintItm'
end
