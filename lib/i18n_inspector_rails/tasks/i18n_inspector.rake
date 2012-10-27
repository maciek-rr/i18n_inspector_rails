namespace :i18n_inspector do

  desc 'Lists unused translations found in locales'
  task :unused_translations do
    locale_yml_files.each do |locale_yml_file|
      puts "Processing #{File.basename(locale_yml_file)}"
      inspector = I18nInspector.new(Rails.root, locale_yml_file)
      puts inspector.unused_keys.map { |uk| "\t#{uk}"}.join("\n")
    end
  end
  
  desc 'Lists keys that are not found in locales'
  task :undefined_keys do
    locale_yml_files.each do |locale_yml_file|
      puts "Processing #{File.basename(locale_yml_file)}"
      inspector = I18nInspector.new(Rails.root, locale_yml_file)
      puts inspector.undefined_keys.map { |uk| "\t#{uk}"}.join("\n")
    end
  end

  def locale_yml_files
    Dir[File.join(Rails.root, 'config/locales', '*.yml')]
  end
  
end