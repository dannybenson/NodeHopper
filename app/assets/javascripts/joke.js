$(document).ready(function() {

  d3.select("p")
    .transition()
    .delay(1000)
    .duration(7000)
    .styleTween("color", function() { return d3.interpolate("yellow","red");});

})
