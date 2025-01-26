class MessagesController < ApplicationController
  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.build(message_params)
    @message.user = current_user

    if @message.save
      ChatChannel.broadcast_to(
        @room,
        message: render_message(@message)
      )

      respond_to do |format|
        format.html { redirect_to room_path(@room) }
        format.js
      end
    else
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def render_message(message)
    ApplicationController.renderer.render(
      partial: "messages/message",
      locals: { message: message }
    )
  end
end
