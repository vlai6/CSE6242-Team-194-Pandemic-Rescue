function drawLegend() {

    const format = 'totals';
    const labels = scales[field][format].labels;
    const title = scales[field][format].title;

    var legend = d3.select("#legend")
        .html("")
        .attr("width", "1000")
        .attr("height", "100")
        .selectAll("g.legend")
        .data(labels)
        .enter()
        .append("g")
        .attr("class", "legend")

    legend.append("rect")
        .attr("x", function(d, i){ return 1000 - (i*ls_w) - ls_w})
        .attr("y", 30)
        .attr("width", ls_w)
        .attr("height", ls_h)
        .style("fill", function(d, i) { return color(d) })

    legend.append("text")
        .attr("x", function(d, i){ return 1000 - (i*ls_w) - ls_w})
        .attr("y", 70)
        .text(function(d, i){ return labels[i] })

    legend.append("text")
        .attr("x", 417)
        .attr("y", 20)
        .text(function(){return title})
        .style("font-size", "25px")
        .style("text-align", "center");
}