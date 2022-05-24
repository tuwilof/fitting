module Fitting
  class Rep
    def initialize(apis)
      @apis = apis
    end

    def save!
      destination = 'coverage'
      FileUtils.mkdir_p(destination)

      gem_path = $LOAD_PATH.find { |i| i.include?('fitting') }
      source_path = "#{gem_path}/templates/htmlcss/fitting.html"

      divs = ""
      res = ""
      @actions = @apis.inject([]) { |res, api| res += api.actions }
      @actions.sort{|a, b| a.cover <=> b.cover }.each do |action|
        key = SecureRandom.hex
        res +=
          "    <tr>"\
          "        <td>#{action.method}</td>"\
          "        <td><a href='##{key}'>#{action.host}#{action.prefix}#{action.path}</a></td>"\
          "        <td#{action.cover == 100 ? ' class="green"' : ' class="red"'}>#{action.cover}%</td>"\
          "        <td>89</td>"\
          "        <td>19</td>"\
          "        <td>9</td>"\
          "        <td>10</td>"\
          "        <td>3.79</td>"\
          "    </tr>"
        divs +=
          "<div id='#{key}' class='overlay'>"\
          "    <div class='popup'>"\
          "        <h2>#{action.method} #{action.host}#{action.prefix}#{action.path}</h2>"\
          "        <a class='close' href='#'>&times;</a>"\
          "        <div class='content'>"\
          "            <code>#{action.to_yaml.gsub("\n", "<Br>").gsub(" ", "&nbsp;")}</code>"\
          "        </div>"\
          "    </div>"\
          "</div>"
      end

      file =  File.read(source_path)
      new_file = file.gsub('<tr></tr>', res).gsub('<div></div>', divs)
      File.open('coverage/fitting.html', 'w') { |file| file.write(new_file) }
    end
  end
end
