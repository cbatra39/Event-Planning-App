class Admin::ReportsController < ApplicationController
    before_action :authenticate_user!
    
    def index
        @reports = Report.all
    end


    def update_status
        @report =  Report.find_by(id:params[:id])
        if @report.report_type == 2 
            @user = User.find_by(id:@report.reported_id)
            if @user.status == "suspended"
                @report.update(status:3)
            else
                AccountSuspensionMailer.suspended(@user).deliver_later
                @user.update(status:"suspended")
                @report.update(status:2)
            end
        else
            @event =  Event.find_by(id:@report.reported_id)
            @user = User.find_by(id: @event.user_id)
            if @event.is_approved == false
                @report.update(status:3)
            else
                AccountSuspensionMailer.event_suspended(@user,@event).deliver_later
                @event.update(is_approved:false)
                @report.update(status:2)
            end
        end
        redirect_to admin_reports_path
    end


    def disapprove
        @report = Report.find_by(id:params[:id])
        if(@report.status == 1)
            @report.update(status:0)
        end
        redirect_to admin_reports_path
    end


    def show
        @report = Report.find_by(id:params[:id])
        if @report.report_type == 1
            @data = Event.find_by(id:@report.reported_id)
        else
            @data =User.find_by(id:@report.reported_id)
        end
    end


end