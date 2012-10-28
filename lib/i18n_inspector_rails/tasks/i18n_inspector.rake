namespace :i18n_inspector do

  # Possible params: exclude_locales=en,de

  desc 'Runs both'
  task :report => [:unused_translations, :undefined_keys]

  desc 'Lists unused translations from locales'
  task :unused_translations do
    puts "\nLooking up unused translations from locales"
    locale_files.each do |locale_yml_file|
      puts "Processing #{File.basename(locale_yml_file)}"
      inspector = I18nInspector.new(Rails.root, locale_yml_file)
      unused_keys = inspector.unused_keys
      if unused_keys.any?
        puts "Unused translations:"
        puts unused_keys.map { |uk| "\t#{uk}"}.join("\n")
        puts "Please remember that the list will contain keys that are accessed dynamically."
      else
        puts "No unused translations in #{locale_yml_file} locales found."
      end
    end
  end
  
  desc 'Lists keys lacking translation'
  task :undefined_keys do
    locale_files.each do |locale_yml_file|
      puts "\nLooking up keys with no translation"
      puts "Processing #{File.basename(locale_yml_file)}"
      inspector = I18nInspector.new(Rails.root, locale_yml_file)
      puts inspector.undefined_keys.map { |uk| "\t#{uk}"}.join("\n")
    end
    puts "\n"
  end

  def locale_files
    el = excluded_locales
    Dir[File.join(Rails.root, 'config/locales', '*.yml')].reject do |yml_file|
      el.any? { |excluded_locale| yml_file =~ /\/#{excluded_locale}\z/ } 
    end
  end

  def excluded_locales
    if excluded_locales = ENV["exclude_locales"]
      excluded_locales.downcase.split(',').map {|el| el.include?('.yml') ? el : "#{el}.yml"}
    else
      []
    end
  end

end