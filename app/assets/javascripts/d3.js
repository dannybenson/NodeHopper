$(document).ready(function() {

var w = 500;
var h = 500;
var r = Math.min(w,h)/2;
var color = d3.scale.category20c();

var root = {
  "title": "params",
  "children": [
  {
    "title": "Movies",
    "children":[
    {"title":"Departed",
      "data": 30},
    {"title":"The Shining",
      "data": 70},
    {"title":"The Help",
      "data": 90},
    {"title":"Tomoe",
      "data": 50}
    ]
  },
  {
    "title": "Books",
    "children":[
    {"title":"1984",
      "data": 30},
    {"title":"Mockingjay",
      "data": 69},
    {"title":"Brave New World",
      "data": 23}
    ]
  },
  {
    "title": "TV shows",
    "children":[
    {"title":"OOT",
      "data": 78},
    {"title":"Something Good",
      "data": 20},
    {"title":"Cosmos",
      "data": 92}
    ]
  }
  ]
};

var svg = d3.select("#charts").append("svg")
  .attr("width", w)
  .attr("height", h)
  .append("g")
    .attr("transform","translate(" + w/2 + "," + h/2 + ")");

var partition = d3.layout.partition()
  .size([2*Math.PI, r*r])
  .value(function(d) { return d.data;});

var arc = d3.svg.arc()
  .startAngle(function(d) {return d.x + .01;})
  .endAngle(function(d) {return d.x + d.dx;})
  .innerRadius(function(d){ return r/3 * d.depth;})
  .outerRadius(function(d){ return r/3 * (d.depth + .92) - 2});

var title = d3.select("body").append("text")
  .attr("class", "title")
  .attr("transform", "rotate(20,20,20)")
  .style("position", "absolute")
  .style("visibility","hidden");

var path = svg.datum(root).selectAll("path")
    .data(partition.nodes)
    .enter().append("path")
      .attr("class", function(d) {if (d.data) {return d.title + ","+ d.data} else { return d.title}})
      .attr("d", arc)
      .attr("display", function(d) {return d.depth ? null : "none" ;})
      .attr("fill", function(d) {return color((d.children ? d : d.parent).title);})
      .style("stroke", "#fff")
      .on("mouseover", function(d) {return title.text(this.className.animVal).style("visibility","visible");})
      .on("mousemove", function(d) {return title.style("top", (event.pageY-10) + "px").style("left", (event.pageX+10)+ "px");})
      .on("mouseout", function(d) {return title.style("visibility", "hidden")});

var transition = d3.transition()
  .delay(500)
  .duration(2000);

transition.each(function() {
    d3.selectAll("g").transition()
    .style("opacity", 1)
    .remove;
  })

})