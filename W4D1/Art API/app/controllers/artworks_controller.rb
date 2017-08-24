class ArtworksController < ApplicationController
  require 'byebug'

  def index
    @user = User.find(params[:user_id])
    @artwork = @user.artworks
    render json: @artwork
  end

  def show
    @artwork = Artwork.find(params[:id])
    if @artwork
      render json: @artwork
    else
      render json: @artwork.errors.full_messages, status: 404
    end
  end

  def create
    @artwork = Artwork.new(artwork_params)
    if @artwork.save
      render json: @artwork
    else
      render json: @artwork.errors.full_messages, status: 422
    end
  end

  def update
    @artwork = Artwork.find(params[:id])
    if @artwork.update(artwork_params)
      redirect_to artworks_url
    else
      render plain: @artwork.errors.full_messages, status: 422
    end
  end

  def destroy
    @artwork = Artwork.find(params[:id])
    if @artwork.destroy
      # redirect_to artworks_url
      render json: @artwork
    else
      render json: @artwork.errors.full_messages
    end
  end



private
  def artwork_params
    params.require(:artwork).permit(:title, :image_url, :artist_id)
  end
end
