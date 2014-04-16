$(function(){
    var root;
    var drawVenn = function() {venn.drawD3Diagram(venn.venn(root.set, root.overlap), 300, 300) }
    $("#d3_3").on("submit", function(event) {
    event.preventDefault();
    d3.select("#d3-3-chart svg").remove();
    var input = {list: ["Dollhouse", "Firefly", "Game of Thrones" ]}
    console.log(input);
    $.post("/d3_3", input, function(result) {
    console.log(result);
    return root = result;
  }, "json").done(drawVenn)
    })
})


$("#d33").val()
