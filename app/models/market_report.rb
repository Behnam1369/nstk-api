class MarketReport < ApplicationRecord
  self.table_name = 'MarketReport'
  self.primary_key = 'IdMarketReport'

  def files
    attachments = []
    self.IdFiles.split(',').each do |idattachment|
      attachments << Attachment.find(idattachment)
    end

    attachments
  end
end
