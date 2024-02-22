module SpreeSocial
  module Spree
    module UserRegistrationsControllerDecorator
      def self.prepend(base)
        base.after_action :clear_omniauth, only: :create, if: -> { Flipper.enabled?(:auth_social)}
      end

      private

      def build_resource(*args)
        super
        if Flipper.enabled?(:auth_social)
          spree_current_user.apply_omniauth(session[:omniauth]) if session[:omniauth]
          spree_current_user
        end
      end

      def clear_omniauth
        session[:omniauth] = nil unless spree_current_user.new_record?
      end
    end
  end
end

::Spree::UserRegistrationsController.prepend(SpreeSocial::Spree::UserRegistrationsControllerDecorator)
