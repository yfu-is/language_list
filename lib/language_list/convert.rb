require 'yaml'

module LanguageList
  class Convert

    attr_reader :translations_path, :txt_path, :yml_path
    

    def initialize(data_path)
      @translations_path = File.join(data_path, 'translations')
      @txt_path = File.join(translations_path, 'txt')
      @yml_path = File.join(translations_path, 'yml')
    end

    def call
      truncate_yml_files!
      generate_yml_files!
    end


    private

    def truncate_yml_files!
      FileUtils.rm_rf(yml_path)
      FileUtils.mkdir_p(yml_path)
    end

    def generate_yml_files!
      txt_files = Dir.glob(File.join(txt_path, '*.txt'))
      txt_files.each do |txt_file|
        txt_locale = File.basename(txt_file).split('-')[-1].split('.')[0]
        txt_rows = File.readlines(txt_file, "\n")

        yml_rows = {}

        txt_rows.each do |txt_row|
          language_code, name = txt_row.split(';;')
          yml_rows[language_code.downcase] = name.strip
        end

        File.open(File.join(yml_path, "#{txt_locale.downcase}.yml"), 'w') { |f| f.write(YAML.dump(yml_rows)) }
      end
    end

  end
end
