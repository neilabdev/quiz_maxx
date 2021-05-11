class CreateSubmissions < ActiveRecord::Migration[6.1]
  def change
    create_table :submissions do |t|
      t.belongs_to :user
      t.belongs_to :quiz
      t.float :score, default: 0.0
      t.integer :total_correct, default: 0
      t.integer :total_wrong, default: 0
      t.integer :total_problems, default: 0
      t.datetime :completed_at
      t.string  :status
      t.timestamps
    end

    create_table :answers do |t|
      t.belongs_to :submission
      t.belongs_to :problem
      t.string :value
      t.timestamps
    end
  end
end
