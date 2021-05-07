ActiveAdmin.register Quiz do
  menu label: "Quiz", parent: "Exam", priority: 50
  permit_params :name, :description, :active, :quorum

  filter :id
  filter :name
  filter :active
  filter :created_at
  filter :created_at

  index do
    selectable_column
    id_column

    column :name
    #   column :description
    column :active
    column :created_at
    actions
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :user_id, :name, :description, :active
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :name, :description, :active]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
