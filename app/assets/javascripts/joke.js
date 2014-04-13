$(document).ready(function() {


  d3.select("p")
    .transition()
    .delay(1000)
    .duration(7000)
    .styleTween("color", function() { return d3.interpolate("yellow","red");});

d3.select("h1")
  .transition()
  .delay(2000)
  .duration(7000)
  .styleTween("visibility", function() {return d3.interpolate("hidden","visable");});

})
