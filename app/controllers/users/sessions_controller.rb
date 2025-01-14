# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  layout "background", only: [:new]

  # If you need to customize the behavior for login, you can override methods here:
  # def new
  #   super
  # end
end

