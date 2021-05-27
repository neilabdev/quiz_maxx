class AddProblemSolutionCount < ActiveRecord::Migration[6.1]
  def change
    add_column :problems, :solution_count, :integer ,  default: 0
  end
end
