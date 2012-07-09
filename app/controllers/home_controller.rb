class HomeController < ApplicationController
  def dashboard
    redirect_to deduce_after_sign_in_url
  end
end
