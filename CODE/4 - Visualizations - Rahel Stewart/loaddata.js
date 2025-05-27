function loadData(path) {

    data = new Map();

    d3.json("data/counties-10m.json").then(function(us) {
        d3.csv("data/lookup.csv", function (d) {
            return [+d.FIPS, {"population": +d.Population, "name": d.Admin2 + ", " + d.Province_State}]
        }).then(function(pop) {
            pop = new Map(pop)
            d3.csv(path, function(d) {
                if (d.county === "New York City") d.fips = 36061
                if (!dates.includes(d.date)) {
                    dates.push(d.date)
                    numDays += 1;
                }
                if (data.get(+d.fips)) {
                    x = data.get(+d.fips)
                    x[d.date] = {"cases": +d.cases, "deaths": +d.deaths}
                    data.set(+d.fips, x)
                }
                else {
                    x = {}
                    x[d.date] = {"cases": +d.cases, "deaths": +d.deaths}
                    x["name"] = (pop.get(+d.fips) || {}).name || 'No name'
                    x["id"] = +d.fips
                    x["population"] = (pop.get(+d.fips) || {}).population || 'Unknown population'
                    data.set(+d.fips, x)
                }
                document.getElementById("loading-circle").style.display = "none";
            }).then(function (d) {
                pop.forEach(function (value, key) {
                    if (!data.get(key)) {
                        data.set(key, {"name": value.name, "population": value.population, "id": key})
                    }
                })
                load(us, data)
                
            })
        })
    });
}