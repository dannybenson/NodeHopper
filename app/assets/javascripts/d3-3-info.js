$(function(){
    var root;
    var drawVenn = function() {venn.drawD3Diagram(venn.venn(root.set, root.overlaps), 300, 300) }
    $("#prefetch").on("submit", function(event) {
    event.preventDefault();
    d3.select("#charts svg").remove();
    $.post("/d3_3", function(result) {
    console.log(result);
    return root = result;
  }).done(drawVenn)
    })
})
