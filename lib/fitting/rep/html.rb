module Fitting
  class Rep
    class HTML
      def self.bootstrap(fitting_json, fitting_lock_json)
        File.read("#{$LOAD_PATH.find { |i| i.include?('fitting') }}/templates/htmlcss/bootstrap.html")
      end

      def self.to_s(fitting_json, fitting_lock_json)
        divs = ""
        res = ""
        fitting_json.sort do |a, b|
            (a[1].count(0) == 0 ? 100 : 0) <=> (b[1].count(0) == 0 ? 100 : 0)
          end.each do |action|
          res +=
            "    <tr>"\
          "        <td>#{action[0].split(' ')[0]}</td>"\
          "        <td><a href='##{action[0]}'>#{action[0].split(' ')[1]}</a></td>"\
          "        <td#{(action[1].count(0) == 0 ? 100 : 0) == 100 ? ' class="green"' : ' class="red"'}>#{(action[1].count(0) == 0 ? 100 : 0)}%</td>"\
          "        <td>89</td>"\
          "        <td>19</td>"\
          "        <td>9</td>"\
          "        <td>10</td>"\
          "        <td>3.79</td>"\
          "    </tr>"
          divs +=
            "<div id='#{action[0]}' class='overlay'>"\
          "    <div class='popup'>"\
          "        <h2>#{action[0]}</h2>"\
          "        <a class='close' href='#'>&times;</a>"\
          "        <div class='content'>"\
          "            <code>#{fitting_lock_json[action[0]].join("<Br>").gsub(" ", "&nbsp;")}</code>"\
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
