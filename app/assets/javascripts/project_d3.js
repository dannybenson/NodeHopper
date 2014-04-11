$(document).ready(function() {

d3.select("h1").style("color", "yellow");

  var w = 600;
  var h = 400;
  var r = 00;
  var ir = 100;

  var margin = {top: 400, right:500, bottom: 400, left: 500}

  data = [{"title":"princess bride", "percent":50},{"title":"Mulan", "percent":40}, {"title":"snatch", "percent":10}]

  var color = d3.scale.category20();

  var arc = d3.svg.arc()
    .innerRadius(r)
    .outerRadius(ir);

  var vis = d3.select("#donut")
    .append("svg")
    .data([data])
      .attr("width", margin.left + margin.right)
      .attr("height", margin.top + margin.bottom)
    .append("g")
      .attr("transform", "translate(" + margin.left  + "," + margin.top + ")");

  var pie = d3.layout.pie()
    .value(function(d){ return d.percent; });

  var arcs = vis.selectAll("g.slice")
    .data(pie)
    .enter()
      .append("g")
        .attr("class", "arc");

  arcs.append("path")
    .attr("fill", function(d,i) {return color(i);})
    .attr("d", arc);

  arcs.append("text")
    .attr("transform", function(d) {
        d.innerRadius = 0
        d.outerRadius = r;
        return "translate(" + arc.centroid(d) + ")";
    })
    .attr("text-anchor", "middle")
    .text(function(d,i) { return data[i].title})

    window.addEventListener("keypress", selectArcs, false);

    function selectArcs() {
      d3.selectAll("g.arc > path")
          .each(arcTween);
    }

    function arcTween(){
      d3.select(this)
        .transition().duration(1000)
        .attrTween("d", tweenArc({ value : 0}));
    }

    function tweenArc(b){
      return function(a) {
        var i = d3.interpolate(a,b);
        for (var key in b) a[key] = b[key];
          return function(t) {
            return arc(i(t));
          };
      };
    }
});
