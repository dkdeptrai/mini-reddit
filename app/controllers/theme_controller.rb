class ThemeController < ApplicationController
  def update_theme
    cookies[:theme] = params[:theme]
    head :ok
  end

  def load_theme
    theme = cookies[:theme] || 'dark'
    render json: { theme: theme }
  end
end
