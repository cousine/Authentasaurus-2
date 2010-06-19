class Authentasaurus::PermissionsController < Authentasaurus::AuthentasaurusController
	
	def index
		@permissions = Permission.find :all
		
		respond_to do |format|
			format.html
		end
	end
	
	def show
		@permission = Permission.find params[:id]
		
		respond_to do |format|
			format.html
		end
	end
	
	def new
		@permission = Permission.new
		
		respond_to do |format|
			format.html
		end
	end
	
	def create
		@permission = Permission.new params[:permission]
		
		respond_to do |format|
			if @permission.save
				flash.now[:notice] = "Permission created"
				format.html { redirect_to :action=>:index }
			else
				flash.now[:notice] = "Error creating permission"
				format.html { render :new }
			end
		end
	end
	
	def edit
		@permission = Permission.find params[:id]
		
		respond_to do |format|
			format.html
		end
	end
	
	def update
		@permission = Permission.find params[:id]
		
		respond_to do |format|
			if @permission.update_attributes(params[:permission])
				flash.now[:notice] = "Permission updated"
				format.html { redirect_to @permission }
			else
				flash.now[:notice] = "Error updating permission"
				format.html { render :edit }
			end
		end
	end
	
	def destroy
		@permssion = Permission.find params[:id]
		@permission.destroy()
		
		respond_to do |format|
			format.html { redirect_to :action=>:index }
		end
	end
end