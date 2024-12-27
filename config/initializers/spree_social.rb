Rails.application.config.after_initialize do
  if Spree::Core::Engine.backend_available?
      Rails.application.config.spree_backend.main_menu.add_to_section('integrations',
      ::Spree::Admin::MainMenu::ItemBuilder.new('social_authentication_methods', ::Spree::Core::Engine.routes.url_helpers.admin_authentication_methods_path).
        with_manage_ability_check(::Spree::AuthenticationMethod).
        with_match_path('admin/authentication_methods').
        build
      )
  end
end
