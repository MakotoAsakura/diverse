class ChangeTypeTaxPayslip < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      change_table :payslips do |t|
        dir.up { t.change :tax, :float }
        dir.down { t.change :tax, :integer }

        dir.up { t.change :total_day, :float, default: 0 }
        dir.down { t.change :total_day, :float }

        dir.up { t.change :total, :float, default: 0 }
        dir.down { t.change :total, :float }
      end
    end
  end
end
