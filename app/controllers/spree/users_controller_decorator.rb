module Spree
  module UsersControllerDecorator
    def self.prepended(base)
      base.before_action :set_spree_users, only: :show
    end

    private

    def set_spree_users
      @spree_user = spree_current_user
    end
  end
end

::Spree::UsersController.prepend Spree::UsersControllerDecorator
