class ReportsController < ApplicationController

  def new
    @title_name = params[:record_title]
    @id = params[:record_id]
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    @report.request = request

    if verify_recaptcha(model: @reports)
      if ModMailer.contact_form(report_params).deliver
        flash.now[:notice] = "Thank you for your message"
      else
        flash.now[:error] = "Cannot send message"
        render :new
      end
    end
  end

  private
  def report_params
    params.require(:report).permit(:name, :email, :message, :id, :title)
  end
end
