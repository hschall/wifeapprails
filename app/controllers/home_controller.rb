class HomeController < ApplicationController
  def index
  end

  def master
  end


  def dashboard
  @records = current_user.records if current_user

  # Data for Trends Chart
  if @records.present?
    grouped_data = @records.group_by_month(:fecha, format: "%B").sum(:importe)
    @monthly_labels = grouped_data.keys
    @monthly_expenses = grouped_data.values
  else
    @monthly_labels = []
    @monthly_expenses = []
  end

  # Filter for Summary Cards and Table
  if params[:month].present?
    selected_month = params[:month].to_i # Convert the month parameter to an integer
    filtered_records = @records.where("EXTRACT(MONTH FROM fecha) = ?", selected_month) if @records.present?
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
