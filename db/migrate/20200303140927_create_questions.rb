class CreateQuestions < ActiveRecord::Migration[5.2]
  before_validation :normalize_username_and_email
  def change
    create_table :questions do |t|
      t.string :text
      t.string :answer

      t.timestamps
    end
  end
end
