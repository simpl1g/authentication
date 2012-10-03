ActiveAdmin.register User do

    form do |f|
      f.inputs "Details" do
        f.input :login
        f.input :email
        f.input :password
        f.input :two_step_auth
      end

      f.buttons
    end

end
