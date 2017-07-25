module StatisticsHelper

  def input_over_time
    line_chart Mood.group_by_day(:created_at).count, width: "500px", height: '300px', library: {
      title: {text: 'Activity over time', x: -20},
      yAxis: {
         allowDecimals: false
      }
    }
  end

  def mood_pie_chart
    pie_chart Mood.group(:mood).count, width: "500px", height: '300px'
  end

  def mood_time_graph
    area_chart Mood.group_by_month(:created_at, range: 2.years.ago..Time.now).average(:mood),
    width: "500px", height: '300px', allowDecimals: false
  end

  def mood_sleep_graph
    scatter_chart Mood.pluck(:sleep, :mood), width: "500px", height: '300px'
  end

  def mood_exercise_graph
    scatter_chart Mood.pluck(:exercise, :mood), width: "500px", height: '300px'
  end

end
