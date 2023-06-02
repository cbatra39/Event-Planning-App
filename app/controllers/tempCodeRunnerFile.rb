
  def update
    @event = Event.find(params[:id])
    if @event
      if @event.user == current_user # Check if the event belongs to the current user
        if @event.start_date.present? && @event.start_date > Date.today # Check if the event date is upcoming
          if @event.update(set_params)
            image = params[:image]
            if image.present?
              @event.image.attach(image)
            end
            @event.update(is_approved: false)
            success("Event updated successfully", id: @event.id)
          else
            error("Event update failed")
          end
        else
          error("Event date must be in the future")
        end
      else
        error_403("You are not authorized to update this event") # User is not authorized to update the event
      end
    else
      error_404("Event not found")
    end
  end
