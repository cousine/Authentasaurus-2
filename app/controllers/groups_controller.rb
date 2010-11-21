class GroupsController < ApplicationController
  acts_as_groups
	require_read :index, :show
	require_write :new, :create, :edit, :update, :destroy
end