module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :check_signed_in
  end

  private

  def check_signed_in
    unless user_signed_in?
      redirect_to new_user_session_path, notice: 'You have to sign up or sign in before doing that action.'
      @skip_action = true
    end
  end

  def skip_action?
    @skip_action
  end
end
