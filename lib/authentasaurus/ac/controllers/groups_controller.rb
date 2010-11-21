module Authentasaurus::Ac::Controllers
  module GroupsController
    def self.included(base) # :nodoc:
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
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
            flash.now[:alert] = I18n.t(:create_failed, :scope => [:authentasaurus, :messages, :groups])
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
            format.html { redirect_to :action => :index, :notice => "Group updated" }
          else
            flash.now[:alert] = I18n.t(:update_failed, :scope => [:authentasaurus, :messages, :groups])
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
  end
end