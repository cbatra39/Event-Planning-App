class Admin::EventController < ApplicationController
    before_action :authenticate_user!
    def index
        @events  = Event.all
    end
    def show
        @event =  Event.find_by(id:show_event[:id])
    end
    private
    def show_event
        params.permit(:id)
    end
end