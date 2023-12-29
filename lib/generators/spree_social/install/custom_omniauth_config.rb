class CustomOmniauthConfig
  def self.init_provider(provider, tenant_name)
    Apartment::Tenant.switch(tenant_name) do
      next unless ActiveRecord::Base.connection_pool.with_connection(&:active?)

      next unless ActiveRecord::Base.connection.data_source_exists?('spree_authentication_methods')

      auth_method = Spree::AuthenticationMethod.find_by(provider: provider, environment: ::Rails.env)
      return unless auth_method

      key = auth_method.api_key
      secret = auth_method.api_secret
      Rails.logger.info("[Spree Social] Loading #{auth_method.provider.capitalize} as authentication source")

      Devise.setup do |config|
        config.omniauth provider, key, secret, setup: true, info_fields: 'email, name'
      end
    end
  end
end

Apartment.tenant_names.each do |tenant_name|
  SpreeSocial::OAUTH_PROVIDERS.each do |provider|
    CustomOmniauthConfig.init_provider(provider[1], tenant_name)
  end
end

OmniAuth.config.logger = Logger.new(STDOUT)
OmniAuth.logger.progname = 'omniauth'

OmniAuth.config.on_failure = proc do |env|
  handle_failure(env)
end

def handle_failure(env)
  devise_mapping = Devise.mappings[Spree.user_class.table_name.singularize.to_sym]
  controller_name = ActiveSupport::Inflector.camelize(devise_mapping.controllers[:omniauth_callbacks])
  controller_klass = ActiveSupport::Inflector.constantize("#{controller_name}Controller")
  controller_klass.action(:failure).call(env)
end

Devise.setup do |config|
  config.router_name = :spree
end
