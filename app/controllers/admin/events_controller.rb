class Admin::EventsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_event, only: %i[ show  destroy ]
  
    # GET /users or /users.json
    def index
      @events = Event.all
    end
  
    # GET /users/1 or /users/1.json
    def show
    end
  
    def update_status
      @event = Event.find(params[:id])
      @event.update(is_approved: @event.is_approved == true ? false : true)
      redirect_to admin_events_url
    end
    
  
    # DELETE /users/1 or /users/1.json
    def destroy
      @events.destroy
  
      respond_to do |format|
        format.html { redirect_to admin_events_url, notice: "Event was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_event
        @event = Event.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def event_params
        params.fetch(:event, {})
      end

end