class EmployeeRoleChange < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :role_id, :integer
    add_index :employees, :role_id, using: :btree

    Employee.find_each do |emp|
      emp.update(role_id: Membership.where(rolable_id: emp.id).collect(&:role_id).min)
    end
  end
end
