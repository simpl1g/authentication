ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    div :class => "blank_slate_container", :id => "dashboard_default_message" do
      span :class => "blank_slate" do
        span "Welcome to Active Admin. This is the default dashboard page."
        small "To add dashboard sections, checkout 'app/admin/dashboards.rb'"
      end
    end

    section "Recent Users" do
      table_for User.order(:created_at).limit(5) do
        column :email do |user|
          link_to user.email, [:admin, user]
        end
        column :login
      end
      strong { link_to "View All Users", admin_users_path }
    end

  end
end
