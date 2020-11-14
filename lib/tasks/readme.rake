namespace :readme do
  desc 'Generate http request file from README'
  task :generate_http do
    File.open('astro-api-heroku.http', 'w') do |dest_file|
      copy_lines = false

      File.readlines('README.md').each do |line|
        case line
        when /^```http request$/
          copy_lines = true
        when /^```$/
          copy_lines = false
          dest_file.puts "\n###\n"
        else
          dest_file.puts line if copy_lines
        end
      end
    end
  end
end

