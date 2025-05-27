
var update = function(){};
var slider;
var interval;
var numDays = 0;

var dates = []
    
var paths = {
    cases: "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv",
    deaths: "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv",
    vax: "https://covid.cdc.gov/covid-data-tracker/COVIDData/getAjaxData?id=vaccination_county_condensed_data" 
}
    
var scales =  {
    cases: {
        totals:  {
            title: "Total positive tests",
            labels: [0, 1, 10, 100, 1000, 10000, 100000, 1000000],
            color: [[1, 1000,10000,100000, 1000000], ["#e0e1dd", "#778da9", "#415a77", "#1b263b", "#0d1b2a"]]
        }
    },
    deaths: {
        totals:  {
            title: "Total deaths",
            labels: [0, 1, 10, 100, 1000, 10000],
            color: [[1, 1000, 5000, 10000, 100000],  ["#ecf39e", "#90a955", "#4f772d", "#31572c", "#132a13"]]
        }
    }
};


var field = "deaths"

var container = d3.select("#map")
    .attr("width", 1000)
    .attr("height", 500)

var width = 1200
var height = 500

var graph_width = 300
var graph_height = 300

var svg = container.append("svg")
    .attr("width", width)
    .attr("height", height)

var projection = d3.geoAlbersUsa()

var infobar = d3.select(".tooltip")
    .style("opacity", 0)
    .style("width", 480)

var tooltip = d3.select("body").append("div")
    .attr("class", "tooltip")
    .style("opacity", 0)

var path = d3.geoPath()
    .projection(projection)

function color(num) {
    if (num == 0 || num == null) return "white"

    const format =  'totals';
    const settings = scales[field][format].color;
    return d3.scaleLog(settings[0], settings[1])(num);
}

var ls_w = 73, ls_h = 20

function linepos(x) {
    if (x == 0) return 927
    x = Math.log10(x)
    return 854 - x * ls_w
}

drawLegend();

    
g = svg.append("g")

var zoom = d3.zoom()
    .extent([[0, 0], [width, height]])
    .scaleExtent([1, 10])
    .on("zoom", zoomed)


svg.call(zoom)
svg.on("click", unzoomed)

function zoomed() {
    g.attr("transform", d3.event.transform)
}

function unzoomed() {
    svg.transition().duration(1000).call(
        zoom.transform,
        d3.zoomIdentity,
        d3.zoomTransform(svg.node()).invert([width / 2, height / 2])
    )
}

var clicked_obj = null

var search = null
var topo = null

d3.select('.data.dropdown').on('change', function() {
    var option = d3.select(this).property('value');
    field = option;
    drawLegend();
    update(dates.length - 1, interval.property('value'))
});



var data;

loadData(paths.cases);


