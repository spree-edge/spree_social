Deface::Override.new(
  virtual_path: 'spree/user_registrations/new',
  name: 'add_socials_to_login_extras',
  insert_after: '[data-hook="login_extras"]',
  text: '<% if Flipper.enabled?(:auth_social) %>
          <%= render partial: "spree/shared/social" unless session[:omniauth] %>
        <% end %>'
)

Deface::Override.new(
  virtual_path: 'spree/user_sessions/new',
  name: 'add_socials_to_login_extras',
  insert_after: '[data-hook="login_extras"]',
  partial: 'spree/shared/social'
)

Deface::Override.new(
  virtual_path: 'spree/user_registrations/new',
  name: 'remove_new_customer_if_sessionomniauth',
  replace: 'div#new-customer h6',
  partial: 'spree/users/new-customer'
)
