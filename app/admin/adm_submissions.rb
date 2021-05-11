ActiveAdmin.register Submission do
  menu label: "Submissions", parent: "Student", priority: 79
  config.clear_action_items!
  actions :index, :show, :destroy
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :user_id, :quiz_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :quiz_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  #

  index do
    selectable_column
    id_column
    column :user
    column :quiz
    column :score
    column :totals do |r|
      "#{r.total_correct}/#{r.total_problems}"
    end
    column :created_at
    actions
  end

end
