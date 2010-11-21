class UserInvitationsController < ApplicationController
  acts_as_user_invitations
  require_read :index
  require_write :new, :create, :destroy
end
