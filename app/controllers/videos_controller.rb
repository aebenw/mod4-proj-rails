class VideosController < ApplicationController

  def create

    # binding.pry
    video = Video.new(video_params)
    conversation = Conversation.find(video_params[:conversation_id])

    if video.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        VideoSerializer.new(video)
      ).serializable_hash
      binding.pry
      VideosChannel.broadcast_to conversation, serialized_data
      head :ok
    end
  end

    private

    def video_params
      params.require(:video).permit(:conversation_id, :user_id, :kind, :from, :to, :candidate)
    end

end
