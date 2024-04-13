class DashboardController < ApplicationController
  def show
    @account = Account.find(current_user.account_id)
  end
end
