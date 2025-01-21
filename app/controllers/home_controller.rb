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
    grouped_data = case ActiveRecord::Base.connection.adapter_name
                   when "SQLite"
                     @records.group("CAST(strftime('%m', fecha) AS INTEGER)").sum(:importe) # Ensure keys are integers
                   when "PostgreSQL"
                     @records.group("EXTRACT(MONTH FROM fecha)").sum(:importe)
                   else
                     {}
                   end

    # Create all 12 months with default 0 for missing months
    all_months = (1..12).map { |m| Date::MONTHNAMES[m] } # ["January", "February", ..., "December"]
    @monthly_labels = all_months
    @monthly_expenses = (1..12).map do |month|
      grouped_data[month.to_s.to_i] || grouped_data[month] || 0 # Handle keys as both integers and strings
    end
  else
    @monthly_labels = Date::MONTHNAMES[1..12] # ["January", "February", ..., "December"]
    @monthly_expenses = Array.new(12, 0) # Default to 0 for all months
  end

  # Filter for Summary Cards and Table
  if params[:month].present?
    selected_month = params[:month].to_i
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
  @expenses_by_concept = @records
    .select("concepto, COUNT(*) as record_count, SUM(importe) as total_expense, AVG(importe) as avg_ticket")
    .group(:concepto)
    .order("total_expense DESC") # Order by total expense
end




end
