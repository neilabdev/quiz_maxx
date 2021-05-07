class CreateSubmissions < ActiveRecord::Migration[6.1]
  def change
    create_table :submissions do |t|
      t.belongs_to :user
      t.belongs_to :quiz
      t.timestamps
    end

    create_table :answers do |t|
      t.belongs_to :submission
      t.string :value
      t.timestamps
    end
  end
end
