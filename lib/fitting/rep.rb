module Fitting
  class Rep
    def initialize(actions)
      @actions = actions
    end

    def save!
      destination = 'coverage'
      FileUtils.mkdir_p(destination)

      gem_path = $LOAD_PATH.find { |i| i.include?('fitting') }
      source_path = "#{gem_path}/templates/htmlcss/fitting.html"

      res = ""
      @actions.each do |action|
        res +=
          "    <tr>"\
          "        <td>#{action.action.method} #{action.action.path}</td>"\
          "        <td>47.37 %</td>"\
          "        <td>89</td>"\
          "        <td>19</td>"\
          "        <td>9</td>"\
          "        <td>10</td>"\
          "        <td>3.79</td>"\
          "    </tr>"
      end

      file =  File.read(source_path)
      new_file = file.gsub('<tr></tr>', res)
      File.open('coverage/fitting.html', 'w') { |file| file.write(new_file) }
    end
  end
end
