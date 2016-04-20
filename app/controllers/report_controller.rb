class ReportController < ApplicationController

  def new
    @report = Report.new
  end

  def create

    @report = Report.new(report_params)
    @report.request = request

    if ModMailer.contact_form(report_params).deliver
      flash.now[:notice] = "Thank you for your message"
    else
      flash.now[:error] = "Cannot send message"
      render :new
    end
  end

  private
  def report_params
    params.require(report_path).permit(:name, :email, :message)
  end
end
