ActiveAdmin.register Problem do
  menu label: "Problems", parent: "Exam", priority: 79
  permit_params :title, :description, :weight, :solutions ,
                 solutions_attributes: [:id, :value, :correct, :_destroy]
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :weight, :type, :category, :title, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:weight, :type, :category, :title, :description]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  #


  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do # physician's fields
      f.input :title
      f.input :description
      f.input :weight
    end

    f.has_many :solutions,allow_destroy: true, sortable: :priority   do |fs|
      fs.input :value  # it should automatically generate a drop-down select to choose from your existing patients
      fs.input :correct
    end
    f.actions
  end
  
end
