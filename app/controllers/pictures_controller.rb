class PicturesController < ApplicationController
    protect_from_forgery prepend: true

  def create
    @picture = Picture.new(picture_params)
    @picture.save

    respond_to do |format|
      format.json { render :json => { url: @picture.image.url,
                                      picture_id: @picture.id } }
    end
  end

  def destroy
    @picture = Picture.find(id: params[:id])
    @picture.destroy
    respond_to do |format|
      format.json { render :json => { status: :ok } }
    end
  end

  private

  def picture_params
    params.require(:picture).permit(:image)
  end
end
