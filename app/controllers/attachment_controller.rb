class AttachmentController < ApplicationController
  ActiveRecord::ConnectionAdapters::SQLServerAdapter.use_output_inserted = false

  def upload
    id = Attachment.last['IdAttachment'] + 1
    name = "uf#{id}_#{params[:file].original_filename.gsub(/[%$@#&*^()=!~ ]/, '_')}"
    title = params[:file].original_filename
    path = "C:\\Users\\b.aghaali\\SPII\\Site\\uploads\\#{name}"
    File.binwrite(path, params[:file].read)
    @attachment = Attachment.new({ IdAttachment: id, Title: title, Name: name, Size: params[:file].size,
                                   UploadDate: DateTime.now })
    @attachment.save
    render json: { message: 'Success', file: @attachment }
  end

  def show
    @attachment = Attachment.find(params[:idfile])
    render json: { message: 'Success', file: @attachment }
  end
end
