class Authentasaurus::UserInvitationsController < ApplicationController
  # require_read :actions => [:index]
  #   require_write :actions => [:new, :create, :destroy]
  
  def index
    @invitations = UserInvitation.find :all
    
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @invitation = UserInvitation.new
    
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @invitation = UserInvitation.new params[:user_invitation]
    
    respond_to do |format|
      if @invitation.save
        format.html { redirect_to :action => :index }
      else
        format.html {render :new}
      end
    end
  end
  
  def destroy
    invitation = UserInvitation.find params[:id]
    invitation.destroy
    
    respond_to do |format|
      format.html { redirect_to :action => :index }
    end
  end
end
