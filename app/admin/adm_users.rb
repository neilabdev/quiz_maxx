ActiveAdmin.register User do
  menu label: "Users", parent: "System", priority: 100
  permit_params :email, :password, :password_confirmation, :role

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :created_at
    actions
  end

  filter :email
  filter :role, as: :select, collection: User::Role::ALL
  filter :created_at


  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end

    f.inputs "Security" do
      f.input :role, as: :select, collection: User::Role::ALL
    end
    f.actions
  end

  controller do
    def update
      param_model = params[:user]
      if param_model.present? && param_model[:password].blank?
        param_model.delete("password")
        param_model.delete("password_confirmation")
      end
      super
    end
  end

end
