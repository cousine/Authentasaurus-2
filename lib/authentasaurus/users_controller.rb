class Authentasaurus::UsersController < ApplicationController
	require_read :actions => [:index, :show]
	require_write :actions => [:new, :create, :edit, :update, :destroy]
	
	def index
		@users = User.all
		
		respond_to do |format|
			format.html
		end
	end
	
	def show
		@user = User.find(params[:id])
		
		respond_to do |format|
			format.html
		end
	end
	
	def new
		@user = User.new
		
		respond_to do |format|
			format.html
		end
	end
	
	def create
		@user = User.new params[:user]
			
		respond_to do |format|
			if @user.save
				flash.now[:notice] = "User saved successfully"
				format.html { redirect_to :action=>:index }
			else
				flash.now[:notice] = "Error saving user"
				format.html { render :new }
			end
		end
	end
	
	def edit
		@user = User.find params[:id]
		
		respond_to do |format|
			format.html
		end
	end
	
	def update
		@user = User.find params[:id]
		
		respond_to do |format|
			if @user.update_attributes(params[:user])
				flash.now[:notice] = "User updated"
				format.html { redirect_to @user }
			else
				flash.now[:notice] = "Error updating user"
				format.html { render :edit }
			end
		end
	end
	
	def destroy
		@user = User.find params[:id]
		@user.destroy
		
		respond_to do |format|
			format.html { redirect_to :action=>:index }
		end
	end
end