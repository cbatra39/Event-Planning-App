class  Admin::HashtagsController < ApplicationController
  before_action :set_hashtag, only: %i[ show edit update destroy ]

  # GET /hashtags or /hashtags.json
  def index
    @hashtags = Hashtag.all
  end

  # GET /hashtags/1 or /hashtags/1.json
  def show
  end

  # GET /hashtags/new
  def new
    @hashtag = Hashtag.new
  end

  # GET /hashtags/1/edit
  def edit
  end

  # POST /hashtags or /hashtags.json
  def create
    @hashtag = Hashtag.new(hashtag_params)
      if @hashtag.save
        redirect_to admin_hashtag_url(@hashtag), notice: "Hashtag was successfully created." 
      else
        redirect_to new_admin_hashtag_path ,status: :unprocessable_entity 
      end
    
  end

  # PATCH/PUT /hashtags/1 or /hashtags/1.json
  def update
      if @hashtag.update(hashtag_params)
        redirect_to admin_hashtag_url(@hashtag), notice: "Hashtag was successfully updated." 
      else
        redirect_to edit_admin_hashtag_path, status: :unprocessable_entity , notice: "Hashtag could not be updated."
      end
  end

  # DELETE /hashtags/1 or /hashtags/1.json
  def destroy
    @hashtag.destroy

    respond_to do |format|
      format.html { redirect_to hashtags_url, notice: "Hashtag was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hashtag
      @hashtag = Hashtag.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hashtag_params
      params.fetch(:hashtag, {})
    end
end
