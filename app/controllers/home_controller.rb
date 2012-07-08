class HomeController < ApplicationController
  def dashboard
    deduce_after_sign_in_url
  end
end
