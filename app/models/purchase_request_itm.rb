class PurchaseRequestItm < ApplicationRecord
  belongs_to :purchase_request, foreign_key: 'IdPurchaseRequest', optional: true

  self.table_name = 'PurchaseRequestItm'
  self.primary_key = 'IdPurchaseRequestItm'
end
