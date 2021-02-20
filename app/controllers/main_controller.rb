# frozen_string_literal: true

# BigBlueButton open source conferencing system - http://www.bigbluebutton.org/.
#
# Copyright (c) 2018 BigBlueButton Inc. and by respective authors (see below).
#
# This program is free software; you can redistribute it and/or modify it under the
# terms of the GNU Lesser General Public License as published by the Free Software
# Foundation; either version 3.0 of the License, or (at your option) any later
# version.
#
# BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.

class MainController < ApplicationController
  before_action :contact_params, only: [:create_contact]

  include Registrar

  layout 'landing'

  # GET /
  def index
    # Store invite token
    session[:invite_token] = params[:invite_token] if params[:invite_token] && invite_registration
    @contact = ContactForm.new

    redirect_to home_page if current_user
  end

  def create_contact
    @contact = ContactForm.new(contact_params)
    @contact.request = request
    if @contact.deliver
      flash.now[:success] = 'Thank you for your message!'
      render :index
    else
      flash.now[:alert] = 'Cannot send message.'
      render :index
    end
  end

  private
  def contact_params
    params.require(:contact_form).permit(:name, :email, :subject, :message)
  end
end
