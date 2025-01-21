class HomeController < ApplicationController
  def index
  end

  def master
  end


  def dashboard
  @records = current_user.records if current_user

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
        filtered_records = @records.where("CAST(strftime('%m', fecha) AS INTEGER) = ?", selected_month) if @records.present?
      when "PostgreSQL"
        filtered_records = @records.where("EXTRACT(MONTH FROM fecha) = ?", selected_month) if @records.present?
      else
        filtered_records = @records
      end
    else
      flash[:alert] = "Invalid month selected."
      filtered_records = @records
    end
  else
    filtered_records = @records
  end

  # Ensure filtered_records is not nil
  filtered_records ||= []

  # Summary Card Data
  @filtered_total_amount = filtered_records.sum(:importe)
  @filtered_total_records = filtered_records.count
  @filtered_highest_expense = filtered_records.order(:importe).last

  # Data for Table: Total Expenses by Concepto
  @expenses_by_concept = filtered_records.group(:concepto).sum(:importe) || {}
end

end
