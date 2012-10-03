ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    section "Recent Users" do
      table_for User.order('created_at DESC').limit(5) do
        column :email do |user|
          link_to user.email, [:admin, user]
        end
        column :login
      end
      strong { link_to "View All Users", admin_users_path }
    end

  end
end
