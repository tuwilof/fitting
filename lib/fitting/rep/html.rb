module Fitting
  class Rep
    class HTML
      def self.to_s(actions)
        divs = ""
        res = ""
        actions.sort{|a, b| a.cover <=> b.cover }.each do |action|
          res +=
            "    <tr>"\
          "        <td>#{action.method}</td>"\
          "        <td><a href='##{action.key}'>#{action.url}</a></td>"\
          "        <td#{action.cover == 100 ? ' class="green"' : ' class="red"'}>#{action.cover}%</td>"\
          "        <td>89</td>"\
          "        <td>19</td>"\
          "        <td>9</td>"\
          "        <td>10</td>"\
          "        <td>3.79</td>"\
          "    </tr>"
          divs +=
            "<div id='#{action.key}' class='overlay'>"\
          "    <div class='popup'>"\
          "        <h2>#{action.method} #{action.host}#{action.prefix}#{action.path}</h2>"\
          "        <a class='close' href='#'>&times;</a>"\
          "        <div class='content'>"\
          "            <code>#{action.to_yaml.gsub("\n", "<Br>").gsub(" ", "&nbsp;")}</code>"\
          "        </div>"\
          "    </div>"\
          "</div>"
        end

        file =  File.read("#{$LOAD_PATH.find { |i| i.include?('fitting') }}/templates/htmlcss/fitting.html")
        file.gsub('<tr></tr>', res).gsub('<div></div>', divs)
      end
    end
  end
end
