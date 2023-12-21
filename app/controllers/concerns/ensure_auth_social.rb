module EnsureAuthSocial
  extend ActiveSupport::Concern

  # filter for checking if this feature is enabled or not before running any controller action
  included do
    before_action :ensure_auth_social_enabled
  end

  def ensure_auth_social_enabled
    raise CanCan::AccessDenied unless Flipper.enabled?(:auth_social)
  end
end
