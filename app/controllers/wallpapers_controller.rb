# == Schema Information
#
# Table name: wallpapers
#
#  id          :integer          not null, primary key
#  image       :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class WallpapersController < ApplicationController
  before_action :authenticate_mod!
  before_action :set_wallpaper, only: [:show, :edit, :update, :destroy]

  # GET /wallpapers
  def index
    @wallpapers = Wallpaper.all
  end

  # GET /wallpapers/1
  def show
  end

  # GET /wallpapers/new
  def new
    @wallpaper = Wallpaper.new
  end

  # GET /wallpapers/1/edit
  def edit
  end

  # POST /wallpapers
  def create
    @wallpaper = Wallpaper.new(wallpaper_params)

    if @wallpaper.save
      redirect_to wallpapers_url, notice: 'Wallpaper was successfully created.'
    else
      redirect_to wallpapers_url, notice: 'Something was wrong, please try again.'
    end
  end

  # PATCH/PUT /wallpapers/1
  def update
    if @wallpaper.update(wallpaper_params)
      redirect_to wallpapers_url, notice: 'Wallpaper was successfully updated.'
    else
      redirect_to wallpapers_url, notice: 'Something was wrong, please try again.'
    end
  end

  # DELETE /wallpapers/1
  def destroy
    @wallpaper.destroy
    redirect_to wallpapers_url, notice: 'Wallpaper was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wallpaper
      @wallpaper = Wallpaper.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def wallpaper_params
      params.require(:wallpaper).permit(:image, :description)
    end
end
