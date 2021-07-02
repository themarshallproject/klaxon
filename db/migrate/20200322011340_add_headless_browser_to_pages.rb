class AddHeadlessBrowserToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :use_headless_browser, :boolean, default: false
  end
end
