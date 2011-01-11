module Authentasaurus::Ac::Controllers
  module UsersController
    extend ActiveSupport::Concern
    
    module ClassMethods
    end
        
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
          format.html { redirect_to :action=>:index, :notice => "User saved successfully" }
        else
          flash.now[:alert] = I18n.t(:create_failed, :scope => [:authentasaurus, :messages, :users])
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
          format.html { redirect_to :action => :index, :notice => "User updated" }
        else
          flash.now[:alert] = I18n.t(:update_failed, :scope => [:authentasaurus, :messages, :users])
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
end