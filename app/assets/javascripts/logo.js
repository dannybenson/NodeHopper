$(document).ready(function(){
var canvas = d3.select("#logo").append("svg")
  .attr("hieght", 200)
  .attr("width", 300)
  .append("g")
    .attr("transform", "translate(20,30)");

  canvas.append("text")
    .text("N")
    .attr("class","text")
    .style("font-size", 60)
    .attr("fill", "none")
    .attr("stroke","black")
    .attr("stroke-width", 2)
    .attr("x", 17)
    .attr("y", 19);

  canvas.append("circle")
    .attr("r", 25)
    .attr("cx", 90)
    .attr("fill", "none")
    .attr("stroke", "black");

  canvas.append("text")
    .text("DE")
    .style("font-size", 60)
    .attr("class","text")
    .style("stroke", "black")
    .attr("fill", "none")
    .attr("stroke-width", 2)
    .attr("x", 120)
    .attr("y", 19);

  canvas.append("text")
    .text("H")
    .style("font-size", 67)
    .attr("class","text")
    .style("stroke", "black")
    .attr("stroke-width", 2)
    .attr("fill", "none")
    .attr("x", -20)
    .attr("y", 110);

    canvas.append("circle")
    .attr("r", 29)
    .attr("cx", 60)
    .attr("cy", 85)
    .attr("fill", "none")
    .attr("stroke", "black");

    canvas.append("text")
    .text("PPER")
    .style("font-size", 67)
    .attr("class","text")
    .style("stroke", "black")
    .attr("stroke-width", 2)
    .attr("fill", "none")
    .attr("x", 90)
    .attr("y", 110);

    canvas.append("line")
      .attr("x1", 70)
      .attr("y1", 59)
      .attr("x2", 90)
      .attr("stroke", "black")


})
