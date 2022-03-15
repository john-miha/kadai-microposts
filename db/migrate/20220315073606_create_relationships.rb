class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.references :user, null: false, foreign_key: true
      #foreign_key: trueだと、Railsが"follows"テーブルを探しに行ってしまいエラーになるため、
      #usersテーブルを参照するように修正する。
      t.references :follow, null: false, foreign_key: { to_table: :users }

      t.timestamps
      #user_id と follow_id のペアで重複するものが保存されないようにするデータベースの設定
      t.index [:user_id, :follow_id], unique: true
    end
  end
end
