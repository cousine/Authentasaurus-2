class GroupsController < ApplicationController
	require_read :actions => [:index, :show]
	require_write :actions => [:new, :create, :edit, :update, :destroy]
	
	def index
		@groups = Group.find :all
		
		respond_to do |format|
			format.html
		end
	end
	
	def show
		@group = Group.find params[:id]
		
		respond_to do |format|
			format.html
		end
	end
	
	def new
		@group = Group.new
		
		respond_to do |format|
			format.html
		end
	end
	
	def create
		@group = Group.new params[:group]
		
		respond_to do |format|
			if @group.save
				flash.now[:notice] = "Group created"
				format.html { redirect_to :action=>:index }
			else
				flash.now[:notice] = "Error creating group"
				format.html { render :new }
			end
		end
	end
	
	def edit
		@group = Group.find params[:id]
		
		respond_to do |format|
			format.html
		end
	end
	
	def update
		@group = Group.find params[:id]
		
		respond_to do |format|
			if @group.update_attributes(params[:group])
				flash.now[:notice] = "Group updated"
				format.html { redirect_to @group }
			else
				flash.now[:notice] = "Error updating group"
				format.html { render :edit }
			end
		end
		
	end
	
	def destroy
		@group = Group.find params[:id]
		@group.destroy
		
		respond_to do |format|
			format.html { redirect_to :action=>:index }
		end	
	end
	
end