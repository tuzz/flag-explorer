module CountriesHelper

  def histogram
    div = content_tag(:div, nil, :class => "histogram")

    script = javascript_tag <<-JS
      $(".histogram").jqBarGraph({
        data : #{histogram_data},
        sort : "desc",
        postfix : "%"
      });

      $(".graphBar").each(function () {
        var color = $(this).css("backgroundColor");

        if (color === "rgb(255, 255, 255)") {
          $(this).addClass("white");
        }
      });
    JS

    div + script
  end

  def histogram_data
    arrays = @histogram.map do |hex, ratio|
      percent = (ratio * 100).round(1)
      "[#{percent}, '#{hex}', '#{hex}']"
    end

    "new Array(#{arrays.join(",")})"
  end

end
