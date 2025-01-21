class HomeController < ApplicationController
  def index
  end

  def master
  end


  def dashboard
  @records = current_user.records if current_user

  # Admin filtering by user
  if current_user&.admin? && params[:user_id].present?
    @records = Record.where(user_id: params[:user_id])
  elsif current_user
    @records = current_user.records
  end

  # Data for Trends Chart
  if @records.present?
    case ActiveRecord::Base.connection.adapter_name
    when "SQLite"
      grouped_data = @records.group("strftime('%m', fecha)").sum(:importe)
      @monthly_labels = grouped_data.keys.map { |m| Date::MONTHNAMES[m.to_i] } # Convert month numbers to names
    when "PostgreSQL"
      grouped_data = @records.group("EXTRACT(MONTH FROM fecha)").sum(:importe)
      @monthly_labels = grouped_data.keys.map { |m| Date::MONTHNAMES[m.to_i] } # Convert month numbers to names
    else
      grouped_data = {}
      @monthly_labels = []
    end
    @monthly_expenses = grouped_data.values
  else
    @monthly_labels = []
    @monthly_expenses = []
  end

  # Filter for Summary Cards and Table
  if params[:month].present?
    selected_month = params[:month].to_i # Convert the month parameter to an integer
    if selected_month.between?(1, 12)
      case ActiveRecord::Base.connection.adapter_name
      when "SQLite"
        @records = @records.where("CAST(strftime('%m', fecha) AS INTEGER) = ?", selected_month) if @records.present?
      when "PostgreSQL"
        @records = @records.where("EXTRACT(MONTH FROM fecha) = ?", selected_month) if @records.present?
      end
    else
      flash[:alert] = "Invalid month selected."
    end
  end

  # Ensure @records is not nil
  @records ||= []

  # Summary Card Data
  @filtered_total_amount = @records.sum(:importe)
  @filtered_total_records = @records.count
  @filtered_highest_expense = @records.order(:importe).last

  # Data for Table: Total Expenses by Concepto
  @expenses_by_concept = @records.group(:concepto).sum(:importe) || {}
end


end
