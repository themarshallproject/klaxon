if !Rails.env.production? and ENV['SECRET_KEY_BASE'].blank?
  ENV['SECRET_KEY_BASE'] = SecureRandom.hex
  puts "Autogenerating ENV['SECRET_KEY_BASE'] for Rails.env=#{Rails.env} –– ensure you have this set in your production environment, otherwise things will break."
end
