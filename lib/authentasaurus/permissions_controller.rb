module Authentasaurus::PermissionsController
  def self.included(base) # :nodoc:
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
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
  				format.html { redirect_to :action=>:index, :notice => "Permission created" }
  			else
  				flash.now[:alert] = I18n.t(:create_failed, :scope => [:authentasaurus, :messages, :permissions])
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
  				format.html { redirect_to :action => :index }
  			else
  				flash.now[:alert] = I18n.t(:update_failed, :scope => [:authentasaurus, :messages, :permissions])
  				format.html { render :edit }
  			end
  		end
  	end
  	
  	def destroy
  		@permission = Permission.find params[:id]
  		@permission.destroy
  		
  		respond_to do |format|
  			format.html { redirect_to :action=>:index }
  		end
  	end
  end
end