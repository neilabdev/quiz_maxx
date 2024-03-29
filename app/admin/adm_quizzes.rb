ActiveAdmin.register Quiz do
  menu label: "Quiz", parent: "Exam", priority: 50
  permit_params :name, :title, :description, :active, :quorum,:user_id,  problem_ids: []

  filter :id
  filter :name
  filter :title
  filter :active
  filter :created_at
  filter :created_at

  index do
    selectable_column
    id_column

    column :name
    column :title
    #   column :description
    column :active
    column :created_at
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do # physician's fields
      f.input :user, member_label: :email
      f.input :name
      f.input :title
      f.input :description
      f.input :quorum
      f.input :active
    end

    f.inputs "Problems" do
      f.input :problems, :as => :check_boxes,:member_label=> :title
    end
    f.actions
  end

  show do |f|
    panel "Quiz Details" do
      attributes_table_for  resource do
        row :name
        row :title
        row :description
        row :active
        row :quorum
        row :created_at
        row :updated_at
      end

    end

    panel "Problems" do
      table_for  resource.problems do
        column :id do |r|
          link_to r.id, admin_problem_path(r)
        end
        column  :title do |r|
          link_to r.title, admin_problem_path(r)
        end

        column :created_at
      end
    end
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
