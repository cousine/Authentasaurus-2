class Authentasaurus::RecoveriesController < ApplicationController
  def new
    @recovery = Recovery.new
    
    respond_to do |format|
      format.html
    end
  end

  # def create
  #     respond_to do |format|
  #       user = User.find_by_email(params[:recovery][:email])
  #       if user.nil?
  #         @recovery = Recovery.new
  #         @recovery.errors.add_to_base t(:recovery_email_unknown, :scope => [:authentasaurus, :messages, :recoveries])
  #         format.html { render :action => :new }
  #       else
  #         @recovery = Recovery.find_or_initialize_by_user_id(:user => user)
  #         @recovery.email = params[:recovery][:email]
  #         if @recovery.save
  #           @recovery.touch
  #           format.html { redirect_to new_session_path, :notice => t(:recovery_email_sent, :scope => [:authentasaurus, :messages, :recoveries], :email => params[:recovery][:email]) }
  #         else
  #           format.html { render :new }
  #         end
  #       end
  #     end
  #   end
  
  def create
    @recovery = Recovery.find_or_initialize_by_email :email => params[:recovery][:email]
    
    if @recovery.new_record?
      @recovery.user = User.find_by_email @recovery.email
    end
    
    respond_to do |format|
      if @recovery.save
        @recovery.touch
        format.html { redirect_to new_session_path, :notice => t(:recovery_email_sent, :scope => [:authentasaurus, :messages, :recoveries], :email => @recovery.email) }
      else
        format.html {render :new}
      end
    end  
  end

  def edit
    @recovery = Recovery.valid.find_by_token(params[:token])
    
    respond_to do |format|
	    unless @recovery.nil?
	    	@user = @recovery.user
	    	format.html
	  	else
	    	format.html { redirect_to new_session_path, :alert => t(:recovery_failed, :scope => [:authentasaurus, :messages, :recoveries], :email => params[:email]) }
	  	end
  	end
  end
  
  def destroy
    @recovery = Recovery.find_by_token params[:token]
    @user = @recovery.user
		
		respond_to do |format|
			empty_fields = params[:user].select { |key, value| value.blank? }
			if !empty_fields.empty?
				empty_fields.each do |f|
					@user.errors.add_to_base t(:recovery_field_blank, :scope => [:authentasaurus, :messages, :recoveries], :field => f.first.humanize)
				end
				format.html { render :edit }
			elsif @user.update_attributes params[:user]
				@recovery.destroy
				format.html { redirect_to new_session_path, :notice => t(:recovery_successful, :scope => [:authentasaurus, :messages, :recoveries], :email => params[:email]) }
			else
				format.html { render :edit, :alert => t(:recovery_failed, :scope => [:authentasaurus, :messages, :recoveries], :email => params[:email]) }
			end
		end
  end
end
