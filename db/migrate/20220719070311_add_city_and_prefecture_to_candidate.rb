class AddCityAndPrefectureToCandidate < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :prefecture, :string
    add_column :candidates, :city, :string
  end
end
