class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end
  
  protected

    def self.permission
      return name = controller_name.classify.constantize rescue nil
    end

    def current_ability
      @current_ability ||= Ability.new(current_user)
    end
       
    def load_permissions
      current_user.roles.each do |role|
        @current_permissions = role.permissions.collect{|i| [i.subject_class, i.action]}
      end
    end

    def is_super_admin?
      redirect_to root_path and return unless current_user.super_admin?
    end

end
