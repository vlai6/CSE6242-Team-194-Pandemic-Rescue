function load(us, data) {

    topo = topojson.feature(us, us.objects.counties).features
    var names = []
    topo.forEach(function (d) {
        if (data.get(+d.id)) names.push(data.get(+d.id).name.toLowerCase().split(',')[0])
        else names.push("")
    })

   
    counties = g.selectAll("path")
        .data(topo)
        .enter()
        .append("path")
            .attr("d", path)
            .attr("class", "county")
            .attr("id", function (d) {
                dates.forEach(function (date) {
                    if (!data.get(+d.id)) return
                    if (!(date in data.get(+d.id))) {
                        x = data.get(+d.id)
                        x[date] = {"cases": 0, "deaths": 0}
                        data.set(+d.id, x)
                    }
                })
                return "id-" + +d.id
            })
            .on("click", clicked)

    states = g.append("path")
        .datum(topojson.feature(us, us.objects.states, function(a, b) { return a !== b }))
            .attr("class", "states")
            .attr("d", path)

    names = new Map([...names.entries()].sort())

    slider = d3.select(".slider")
        .append("input")
            .attr("class", "custom-range")
            .attr("type", "range")
            .attr("min", 0)
            .attr("max", dates.length - 1)
            .attr("step", 1)
            .on("input", function() {
                update(slider.property('value'), interval.property('value'))
            })

    interval = d3.select(".slider-interval")
        .append("input")
            .attr("class", "custom-range")
            .attr("type", "range")
            .attr("min", 0)
            .attr("max", numDays)
            .property('value', numDays)
            .attr("step", 1)
            .on("input", function() {
                update(slider.property('value'), interval.property('value'))
            })

    function clicked(d) {
        if (data.get(+d.id).id == clicked_obj) {
            unzoomed()
            clicked_obj = null
            counties.style("opacity", "1")
            infobar.transition()
                .duration(250)
                .style("opacity", 0)
            return
        }
        infobar.selectAll("*").remove();
        infobar.transition()
            .duration(250)
            .style("opacity", 1)

        clicked_obj = data.get(+d.id).id

        counties.style("opacity", 0.5)
        d3.selectAll("#id-" + data.get(+d.id).id)
            .style("opacity", "1")

        const [[x0, y0], [x1, y1]] = path.bounds(d)
        d3.event.stopPropagation()
        svg.transition().duration(1000).call(
            zoom.transform,
            d3.zoomIdentity
                .translate(width / 2, height / 2)
                .scale(Math.min(10, 0.9 / Math.max((x1 - x0) / width, (y1 - y0) / height)))
                .translate(-(x0 + x1) / 2, -(y0 + y1) / 2),
            d3.mouse(svg.node())
        )

        update(slider.property("value", interval.property('value')))
    }

    function getData(item, key, property, interval) {
        const startDate = dates[key - interval];
        const endDate = dates[key];

        if (item && endDate in item) {
            var start = (item[startDate] || {})[property] || 0;
            var end = (item[endDate] || {})[property] || 0;

            const total = end && start ? end - start : end;
            return Math.abs(total);
        }
    }

    update = function (key, interval){
        updateNewCharts1(dates[key]);
        updateNewCharts2(dates[key]);
        updateNewCharts3(dates[key]);
        updateNewCharts4(dates[key]);
        updateNewCharts5(dates[key]);
        infobar.selectAll("*").remove();
        slider.property("value", key)
        d3.select(".date")
            .text(dates[key])
        d3.select(".interval")
            .text(interval && interval !== numDays ? `Last ${interval} days` : 'All data')
        counties.style("fill", function(d) {
                const item = data.get(+d.id);
                return color(getData(item, key, field, interval))
            })
            .on("mouseover", function(d) {
                var obj = d3.selectAll("#id-" + data.get(+d.id).id)
                var item = data.get(+d.id);
                var cases = getData(item, key, field, interval, false);

                if (clicked_obj) obj.style("opacity", 1)
                else obj.style("opacity", 0.2)

                tooltip.transition()
                    .duration(250)
                    .style("opacity", 1)
                tooltip.html(makeTooltip())
                    .style("left", (d3.event.pageX + 15) + "px")
                    .style("top", (d3.event.pageY - 28) + "px")

                function makeTooltip(){
                    const type = field == 'cases' ? 'case' : 'death';
                    return `<p>
                        <strong>${data.get(+d.id).name}</strong><br>
                        ${cases.toLocaleString()} confirmed ${type}${cases == 1 ? "" : "s"}
                    </p>`
                }
            })
            .on("mousemove", function (d) {
                tooltip
                    .style("left", (d3.event.pageX + 15) + "px")
                    .style("top", (d3.event.pageY - 28) + "px")
            })
            .on("mouseout", function (d) {
                var obj = d3.selectAll("#id-" + data.get(+d.id).id)
                if (clicked_obj != data.get(+d.id).id) {
                    if (clicked_obj) obj.transition()
                        .duration(150)
                        .style("opacity", 0.5)
                    else obj.transition()
                        .duration(150)
                        .style("opacity", 1)
                }

                tooltip.transition()
                    .duration(250)
                    .style("opacity", 0)
            })

        if (clicked_obj == null) return

        d = {"id": clicked_obj}

        var cases = data.get(+d.id)[dates[key]].cases
        var deaths = data.get(+d.id)[dates[key]].deaths

        infobar.append("h3").text(data.get(+d.id).name)
        infobar.append("p").text(cases.toLocaleString() + " confirmed case" + (cases == 1 ? "" : "s"))
        infobar.append("p").text(deaths.toLocaleString() + " death" + (deaths == 1 ? "" : "s"))
        infobar.append("p").text(data.get(+d.id).population.toLocaleString() + " people")

        var line = infobar.append("svg")
            .attr("height", graph_height + 50)
            .attr("width", graph_width + 50)
            .append("g")
            .attr("transform", "translate(40, 10)")

        dat = []
        dat_deaths = []
        start = dates.length
        for (var id = 0; id < dates.length; id++) {
            if (data.get(+d.id)[dates[id]].cases > 0) {
                if (start == dates.length) {
                    dat.push({"x": id - 1, "y": 0})
                    dat_deaths.push({"x": id - 1, "y": 0})
                    start = id
                }
            }
            if (start != dates.length) {
                dat.push({"x": id, "y": data.get(+d.id)[dates[id]].cases})
                dat_deaths.push({"x": id, "y": data.get(+d.id)[dates[id]].deaths})
            }
        }

        var x = d3.scaleLinear()
            .domain([start - 1, dates.length - 1])
            .range([0, graph_width])

        line.append("g")
            .attr("transform", "translate(0, " + graph_height + ")")
            .call(d3.axisBottom(x).tickFormat((d, i) => dates[d]))
            .selectAll(".tick text")
            .style("text-anchor", "end")
            .attr("transform", "rotate(-45) translate(-3, 0)")

        var y = d3.scaleLinear()
            .domain([0, d3.max(dat, function(d) {
                return parseInt(d.y)
            })])
            .range([graph_height, 0])

        line.append("g")
            .call(d3.axisLeft(y))
            .attr("transform", "translate(0, 0)")

        line.append("path")
            .datum(dat)
            .attr("fill", "none")
            .attr("stroke", "steelblue")
            .attr("stroke-width", 1.5)
            .attr("d", d3.line()
                .x(function(a) { return x(a.x) })
                .y(function(a) { return y(a.y) })
            )

        line.append("path")
            .datum(dat_deaths)
            .attr("fill", "none")
            .attr("stroke", "red")
            .attr("stroke-width", 1.5)
            .attr("d", d3.line()
                .x(function(a) { return x(a.x) })
                .y(function(a) { return y(a.y) })
            )

        if (key - start >= -1) {
            line.append("circle")
                .attr("cx", x(key))
                .attr("cy", y(dat[key - start + 1].y))
                .attr("r", 4)
                .style("fill", "steelblue")
            line.append("circle")
                .attr("cx", x(key))
                .attr("cy", y(dat_deaths[key - start + 1].y))
                .attr("r", 4)
                .style("fill", "red")
        }
    }

    update(dates.length - 1, interval.property('value'))
}