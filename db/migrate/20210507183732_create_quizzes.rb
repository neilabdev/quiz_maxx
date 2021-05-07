class CreateQuizzes < ActiveRecord::Migration[6.1]
  def change
    create_table :quizzes do |t|
      t.belongs_to :user
      t.string :name
      t.text :description
      t.boolean :active, default: true
      t.float :quorum, default: 1.0
      t.timestamps
    end

    create_table :problems do |t|
      t.float :weight, default: 1.0
      t.string :type  # :single,:choice
      t.string :category
      t.string :title
      t.string :description
      t.integer :priority
      t.timestamps
    end

    create_table :quiz_problems do |t|
      t.belongs_to :problem
      t.belongs_to :quiz
      t.timestamps
    end

    create_table :solutions do |t|
      t.belongs_to :problem
      t.string :value
      t.integer :priority
      t.boolean :correct, default: false
      t.timestamps
    end
  end
end