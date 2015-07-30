class AddCompanyNameToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :company_name, :string
  end
end
