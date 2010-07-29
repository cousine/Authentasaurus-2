class Authentasaurus::GroupsController < Authentasaurus::AuthentasaurusController
	
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
				format.html { redirect_to :action=>:index, :notice => "Group created" }
			else
				flash.[:alert] = "Error creating group"
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
				format.html { redirect_to @group, :notice => "Group updated" }
			else
				flash.[:alert] = "Error updating group"
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