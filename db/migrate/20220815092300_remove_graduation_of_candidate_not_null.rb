class RemoveGraduationOfCandidateNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :candidates, :graduation_year, true
  end
end
