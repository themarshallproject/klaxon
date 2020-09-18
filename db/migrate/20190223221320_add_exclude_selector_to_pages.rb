class AddExcludeSelectorToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :exclude_selector, :string
  end
end
