ActiveAdmin.register Problem do
  menu label: "Problems", parent: "Exam", priority: 79
  permit_params :title, :name,:description, :weight, :solutions, :quizzes,
                solutions_attributes: [:id, :value, :correct, :_destroy],
                quiz_ids: []

  filter :name
  filter :category
  filter :description
  filter :quizzes


  index do
    selectable_column
    id_column
    column :name
    column :title
    column :weight
    column :priority

    column :created_at
    actions
  end

  show do |f|
    panel "Details" do
      attributes_table_for  resource do
        row :name
        row :title
        row :description
        row :priority
        row :solution_count
        row :created_at
        row :updated_at
      end

    end

    panel "Problems" do
      table_for  resource.solutions do
        column  :id
        column :value
        column :correct
        column :created_at
      end
    end
  end


  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      # physician's fields
      f.input :name
      f.input :title
      f.input :description
      f.input :weight
    end
    f.inputs "Quizzes" do
      f.input :quizzes, :as => :check_boxes
    end

    f.has_many :solutions, allow_destroy: true, sortable: :priority do |fs|
      fs.input :value # it should automatically generate a drop-down select to choose from your existing patients
      fs.input :correct
    end

    f.actions
  end

end
