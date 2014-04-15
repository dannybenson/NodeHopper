$(document).ready(function() {
  var w = 1200,
    h = 800,
    node,
    link,
    i = 0,
    json;

  var json;

  $("#d3_2").on("submit", function(event) {
    event.preventDefault();
    d3.select("#d3-2-chart svg").remove();
    var input = { search: $("#d3_2 #search").val()};
    $.post("/d3_2", input, function(result) {
      json = result;
    }, "json").done(d3_2);
  })
  var d3_2 = function() {
    var force = d3.layout.force()
      .charge(-1800)
      .size([w, h]);

    var vis = d3.select("#d3-2-chart").append("svg")
      .attr("width", w)
      .attr("height", h);

    update();


    function update() {
      var nodes = flatten(json);
          nodes = nodes.sort(function (a, b) {
                    return a.id - b.id;
                  });

      var links = d3.layout.tree().links(nodes);

      // Restart the force layout.
      force.nodes(nodes)
          .links(links)
          .linkDistance(55)
          .start();

      var link = vis.selectAll(".link")
          .data(links, function(d) { return d.target.id; });

      link.enter().append("line")
          .attr("class", "link");

      link.exit().remove();

      var node = vis.selectAll("g.node")
          .data(nodes)


      var groups = node.enter().append("g")
          .attr("class", "node")
          .attr("id", function (d) {
          return d.id
      })
          .on('click', click)



      groups.append("circle")
          .attr("r", function(d) { return d.size * 5 || 15})
          .style("fill", "#0196A7")


      groups.append("text")
          .attr("dx", 12)
          .attr("dy", "0.35em")
          .style("font-size", "10px")
          .text(function (d) {
          return d.name
      });

      node.exit().remove();

      force.on("tick", function () {
          link.attr("x1", function (d) {
              return d.source.x;
          })
              .attr("y1", function (d) {
              return d.source.y;
          })
              .attr("x2", function (d) {
              return d.target.x;
          })
              .attr("y2", function (d) {
              return d.target.y;
          });

          node.attr("transform", function (d) {
              return "translate(" + d.x + "," + d.y + ")";
          });
      });
    }

    // Color leaf nodes orange, and packages white or blue.
    function color(d) {
      return d._children ? "#3182bd" : d.children ? "#c6dbef" : "#fd8d3c";
    }

    // Toggle children on click.
    function click(d) {
      if (d.children) {
          d._children = d.children;
          d.children = null;
          update();
      } else if (d._children) {
          d.children = d._children;
          d._children = null;
          update();
      } else {
        $.get('/children', {name: d.name}, function(data) {
          d.children = data["children"]
          update();
        })
      }
    }

    // Returns a list of all nodes under the json.
    function flatten(json) {
      var nodes = [];

      function recurse(node) {
          if(!node.id) node.id = ++i;
          nodes.push(node);
          if (node.children) node.children.forEach(recurse);
      }

      recurse(json);
      return nodes;
    }
  }
})

