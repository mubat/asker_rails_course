class ApplicationController < ActionController::Base
  before_action :gon_set_user

  private

  def gon_set_user
    gon.user_id = current_user.id if current_user
  end
end
