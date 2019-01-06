module Codebreaker
class StorageInterceptor
    DEFAULT_PATH_TO_FILE = './data/stat.yml'.freeze

    def initialize(path_to_file = DEFAULT_PATH_TO_FILE)
      @path_to_file = path_to_file.empty? ? DEFAULT_PATH_TO_FILE : path_to_file
    end

    def read_database
      YAML.load_file(@path_to_file) if File.exist?(@path_to_file)
    end

    def write_database(library)
      File.open(@path_to_file, 'w') { |file| file.write(library.to_yaml) }
    end
  end
end
