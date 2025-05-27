function createLineChart(data, containerId, yProperty, yAxisLabel, lineColor, xScale, yScale, reddotid) {
    // Set up SVG dimensions
    var margin = { top: 20, right: 30, bottom: 70, left: 60 },
        width = 800 - margin.left - margin.right,
        height = 500 - margin.top - margin.bottom;

    // Append SVG to the container
    var svg = d3.select(containerId)
                .append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    // Set up X scale
    var x = xScale
              .domain(d3.extent(data, function(d) { return d.date; }))
              .range([0, width]);

    // Set up Y scale
    var y = yScale
              .domain([0, d3.max(data, function(d) { return d[yProperty]; })])
              .range([height, 0]);

    // Add X axis with more ticks
    svg.append("g")
       .attr("transform", "translate(0," + height + ")")
       .call(d3.axisBottom(x).ticks(d3.timeMonth.every(3))
       .tickFormat(d3.timeFormat("%b %Y")))
       .selectAll("text")
       .style("text-anchor", "end")
       .attr("transform", "rotate(-45)")
       .attr("dx", "-0.8em")
       .attr("dy", "0.15em");
  svg.append("text")
       .attr("x", width / 2)
       .attr("y", height + margin.top + 35)
       .style("text-anchor", "middle")
       .text("Date");
    // Add Y axis
    svg.append("g")
    .call(d3.axisLeft(y));

// Append Y axis label
svg.append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 0 - margin.left)
    .attr("x", 0 - (height / 2))
    .attr("dy", "1em") // Adjust the dy attribute to fine-tune vertical position
    .style("text-anchor", "middle")
    .text(yAxisLabel);

    // Add line
    svg.append("path")
       .datum(data)
       .attr("fill", "none")
       .attr("stroke", lineColor)
       .attr("stroke-width", 2)
       .attr("d", d3.line()
                  .curve(d3.curveMonotoneX) // Smooth line curve
                  .x(function(d) { return x(d.date); })
                  .y(function(d) { return y(d[yProperty]); }));

    // Add red dot
    svg.append("circle")
       .attr("id", reddotid)
       .attr("r", 9)
       .style("fill", "red");
    
    return {x: x, y: y};
  }
  function formatDatee(dateString) {
    // Split the date string into month, day, and year components
    var dateParts = dateString.split('-');
    var  year = dateParts[0];
    var month = dateParts[1];
    var day  = dateParts[2];
    return  day + '/' + month + '/' + year;;
}
  d3.csv("data/GDP.csv").then(function(data) {
    var parseDate = d3.timeParse("%d/%m/%Y");
    var filteredData = [];
    data.forEach(function(d) {
      d.date = parseDate(d.date);
      d.GDP = +d.GDP;
      
      if (d.date >= new Date(2015, 0, 1)) {
        filteredData.push(d);
      }
    });
    
       // Create chart for emratiio
       var xScaleFedfunds = d3.scaleTime();
       var yScaleFedfunds = d3.scaleLinear();
       var scalesGDP  = createLineChart(filteredData, "#GDP_chart", "GDP", "GDP", "steelblue", xScaleFedfunds, yScaleFedfunds , "redDotGDP");

       updateNewCharts1 = function(curDate) {
        baseupdatechart(scalesGDP,filteredData ,curDate ,"#GDP_chart #redDotGDP", "GDP");
        };
  });
  function formatDate(dateString) {
    // Split the date string into month, day, and year components
    var dateParts = dateString.split('/');
    var  year = dateParts[0];
    var month = dateParts[1];
    var day  = dateParts[2];
    return  day + '/' + month + '/' + year;;
}
  d3.csv("data/vaccine_test_stringency.csv").then(function(data) {
    var parseDate = d3.timeParse("%d/%m/%Y");
    var filteredData = [];
    data.forEach(function(d) {
      d.date = parseDate(formatDate(d.date));
      // d.total_tests_per_thousand = d.total_tests_per_thousand;
      // d.GDP = +d.GDP;
      if (d.date >= new Date(2015, 0, 1)) {
        filteredData.push(d);
      }
    });
    // console.log(data);
       // Create chart for emratiio
       var xScaleFedfunds = d3.scaleTime();
       var yScaleFedfunds = d3.scaleLinear();
       var result  = createLineChart(filteredData, "#vaccine_chart", "total_tests_per_thousand", "Total Tests Per Thousand", "steelblue", xScaleFedfunds, yScaleFedfunds , "redDotvaccine");

       updateNewCharts5 = function(curDate) {
        baseupdatechart(result, filteredData ,curDate ,"#vaccine_chart #redDotvaccine", "total_tests_per_thousand");
        };
  });
  d3.csv("data/EMRATIO.csv").then(function(data) {
    var parseDate = d3.timeParse("%d/%m/%Y");
    var filteredData = [];
    data.forEach(function(d) {
      d.date = parseDate(d.date);
      d.EMRATIO = +d.EMRATIO;

      if (d.date >= new Date(2015, 0, 1)) {
        filteredData.push(d);
      }
    });

       // Create chart for emratiio
       var xScaleFedfunds = d3.scaleTime();
       var yScaleFedfunds = d3.scaleLinear();
       var result = createLineChart(filteredData, "#emratiio_chart", "EMRATIO", "EMRATIO", "steelblue", xScaleFedfunds, yScaleFedfunds , "redDotemratiio");

       updateNewCharts2 = function(curDate) {
        baseupdatechart(result,filteredData ,curDate ,"#emratiio_chart #redDotemratiio", "EMRATIO");
        };
  });

  d3.csv("data/SP500.csv").then(function(data) {
    var parseDate = d3.timeParse("%d/%m/%Y");
    var filteredData = [];
    data.forEach(function(d) {
      d.Open = +d.Open;
      d.date = parseDate(d.date);
      // console.log(d.date);
      if (d.date >= new Date(2015, 0, 1)) {
        filteredData.push(d);
      }
    });

    filteredData.sort(function(a, b) {
      return a.date - b.date;
  });

  var filteredData = filteredData.filter(function(d, i) {
      // Sample every nth data point (adjust n to your preference)
      var n = 2; // Sample every 5th data point
      return i % n === 0;
  });
       var xScaleFedfunds = d3.scaleTime();
       var yScaleFedfunds = d3.scaleLinear();
       var scalesp500 = createLineChart(filteredData, "#sp500_chart", "Open", "Price", "steelblue", xScaleFedfunds, yScaleFedfunds , "redDotsp500");

       updateNewCharts3 = function(curDate) {
        baseupdatechart(scalesp500,filteredData ,curDate ,"#sp500_chart #redDotsp500", "Open");
        };
  });

  d3.csv("data/economic_relief.csv").then(function(data) {
    // Parse the date and numeric values
    var parseDate = d3.timeParse("%d/%m/%Y");
    var filteredData = [];
    data.forEach(function(d) {
      d.date = parseDate(d.date);
      d.CURRCIR = +d.CURRCIR;
      d.FEDFUNDS = +d.FEDFUNDS;

      if (d.date >= new Date(2015, 0, 1)) {
        // Add the data point
        filteredData.push(d);
      }
    });
    
    // Create chart for CURRCIR
    var xScaleCurrcir = d3.scaleTime();
    var yScaleCurrcir = d3.scaleLinear();
    var scalesCurrcir = createLineChart(filteredData, "#currcir_chart", "CURRCIR", "CURRCIR", "steelblue", xScaleCurrcir, yScaleCurrcir , "redDot");

    // Create chart for FEDFUNDS
    var xScaleFedfunds = d3.scaleTime();
    var yScaleFedfunds = d3.scaleLinear();
    var scalesFedfunds = createLineChart(filteredData, "#fedfunds_chart", "FEDFUNDS", "FEDFUNDS", "steelblue", xScaleFedfunds, yScaleFedfunds , "redDotFedfunds");
   

    // Slider functionality
    var slider = document.getElementById("yearSlider");
    var output = document.getElementById("selectedYear");
    updateNewCharts4 = function(curDate) {

      baseupdatechart(scalesCurrcir,filteredData, curDate ,"#currcir_chart #redDot", "CURRCIR");
      baseupdatechart(scalesFedfunds,filteredData, curDate ,"#fedfunds_chart #redDotFedfunds", "FEDFUNDS");
    };
  })
  .catch(function(error) {
    console.log("Error loading data: " + error);
  });

  

  baseupdatechart = function(result,filteredData ,curDate, ids,yColumn) {
    var parseDate = d3.timeParse("%d/%m/%Y");
    selectedYear = parseDate(formatDatee(curDate));
    // console.log(yColumn);
    // var filteredDataOfYear = filteredData.filter(function(d) {
    //     return d.date.getFullYear() === selectedYear.getFullYear() && d.date.getMonth() === selectedYear.getMonth();
    // });

    // if (filteredDataOfYear.length === 0) {
        // If no data is found for the selected year and month, find the closest date
        // filteredDataOfYear = filteredData.reduce(function(prev, curr) {
        //     return Math.abs(curr.date - selectedYear) < Math.abs(prev.date - selectedYear) ? curr : prev;
        // });
        filteredDataOfYear = filteredData.reduce(function(prev, curr) {
          var prevDiff = Math.abs(prev.date - selectedYear);
          var currDiff = Math.abs(curr.date - selectedYear);
          return currDiff < prevDiff ? curr : prev;
        });
        // console.log('closest date');
        // console.log(filteredDataOfYear);
    // }

    // Update chart elements based on filtered data
    console.log(yColumn);
    console.log(filteredDataOfYear.date);
    console.log(result.x(filteredDataOfYear.date));
    d3.select(ids)
        .attr("cx", result.x(filteredDataOfYear.date))
        .attr("cy", function(d) { return result.y(filteredDataOfYear[yColumn]); });
        // .attr("cy", result.y(filteredDataOfYear.FEDFUNDS));


  }