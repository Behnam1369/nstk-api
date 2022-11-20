class AttachmentController < ApplicationController
  
  ActiveRecord::ConnectionAdapters::SQLServerAdapter.use_output_inserted = false
  
  def upload
    id = Attachment.last['IdAttachment'] + 1
    name = 'uf' + id.to_s + '_' + params[:file].original_filename.gsub(/[%$@#&*^()=!~ ]/, '_')
    title = params[:file].original_filename
    path = "D:\\Projects\\SPII\\SPII\\uploads\\"+name
    File.open(path, "wb") { |f| f.write(params[:file].read) }
    @attachment = Attachment.new({IdAttachment: id, Title: title, Name: name, Size: params[:file].size, UploadDate: DateTime.now })
    @attachment.save
    render json: { message: "Hello World", file: @attachment }
  end
end
