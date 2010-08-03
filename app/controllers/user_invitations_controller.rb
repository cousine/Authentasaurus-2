class UserInvitationsController < ApplicationController
  include Authentasaurus::UserInvitationsController
  require_read :index
  require_write :new, :create, :destroy
end
