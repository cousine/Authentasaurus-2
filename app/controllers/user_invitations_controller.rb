class UserInvitationsController < Authentasaurus::UserInvitationsController
  require_read :index
  require_write :new, :create, :destroy
end
