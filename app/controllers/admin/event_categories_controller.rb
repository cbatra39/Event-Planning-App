class Admin::EventCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_category, only: %i[ show edit update destroy ]

  # GET /event_categories or /event_categories.json
  def index
    @event_categories = EventCategory.all
  end

  # GET /event_categories/1 or /event_categories/1.json
  def show
  end

  # GET /event_categories/new
  def new
    @event_category = EventCategory.new
  end

  # GET /event_categories/1/edit
  def edit
  end

  # POST /event_categories or /event_categories.json
  def create
    @event_category = EventCategory.find_by(event_category: event_category_params[:event_category])
    if @event_category.nil?
      @event_category = EventCategory.new(event_category_params)

      respond_to do |format|
        if @event_category.save
          format.html { redirect_to admin_event_categories_url(@event_category), notice: "Event category was successfully created." }
          format.json { render :show, status: :created, location: @event_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event_category.errors, status: :unprocessable_entity }
      end
    end
    else 
      format.html { render :new, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /event_categories/1 or /event_categories/1.json
  def update
    respond_to do |format|
      if @event_category.update(event_category_params)
        format.html { redirect_to event_category_url(@event_category), notice: "Event category was successfully updated." }
        format.json { render :show, status: :ok, location: @event_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event_category.errors, status: :unprocessable_entity }
      end
    end
  end


  def update_status
    @event_category = EventCategory.find(params[:id])
    @event_category.update(status: @event_category.status==true ? false : true)
    redirect_to admin_event_categories_url
  end
  

  # DELETE /event_categories/1 or /event_categories/1.json
  def destroy
    @event_category.destroy

    respond_to do |format|
      format.html { redirect_to admin_event_categories_url, notice: "Event category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_category
      @event_category = EventCategory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_category_params
      params.require(:event_category).permit(:event_category, :status)
    end
end
