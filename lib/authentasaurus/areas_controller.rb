class Authentasaurus::AreasController < Authentasaurus::AuthentasaurusController
	
	def index
		@areas= Area.find :all
		
		respond_to do |format|
			format.html
		end
	end
	
	def show
		@area = Area.find params[:id]
		
		respond_to do |format|
			format.html
		end
	end
	
	def new
		@area = Area.new
		
		respond_to do |format|
			format.html
		end
	end
	
	def create
		@area = Area.new params[:area]
		
		respond_to do |format|
			if @area.save
				format.html { redirect_to :action=>:index, :notice => "Area Created" }
			else
				flash[:alert] = "Error creating area"
				format.html { render :new }
			end
		end
	end
	
	def edit
		@area = Area.find params[:id]
		
		respond_to do |format|
			format.html
		end
	end
	
	def update
		@area = Area.find params[:id]
		
		respond_to do |format|
			if @area.update_attributes(params[:area])
				format.html { redirect_to @area, :notice => "Area updated" }
			else
				flash[:alert] = "Error updating area"
				format.html { render :edit }
			end
		end
	end
	
	def destroy
		@area = Area.find params[:id]
		@area.destroy
		
		respond_to do |format|
			format.html { redirect_to :action=>:index }
		end
	end
end