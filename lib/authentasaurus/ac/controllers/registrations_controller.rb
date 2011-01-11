module Authentasaurus::Ac::Controllers
  module RegistrationsController
    extend ActiveSupport::Concern
    
    module ClassMethods
    end
        
    def new
      @user = User.new
      @user_invitation = UserInvitation.find_by_token params[:token]
      
      respond_to do |format|
        if @user_invitation.nil?
          format.html {redirect_to new_authentasaurus_session_path, :alert => t(:invalid_invitation_token, :scope => [:authentasaurus, :messages, :user_invitations])}
        else
          @user.email = @user_invitation.email
          format.html
        end
      end
    end
    
    def create
      @user = User.new params[:user]
      user_invitation = UserInvitation.find_by_token params[:token]
      
      respond_to do |format|
        unless user_invitation.nil?
          if @user.save
            format.html {redirect_to new_authentasaurus_session_path}
          else
            format.html {render :new}
          end
        else
          flash.now[:alert] = t(:invalid_invitation_token, :scope => [:authentasaurus, :messages, :user_invitations])
          format.html {render :new}
        end
      end
    end
  end
end