$(document).ready(function() {

  //dynamic list
  var index = 0
  function TodoController() {
      this.index = 0
    }

    TodoController.prototype = {
      bindEvents : function() {
        // $("#d3_1 form").submit(this.create.bind(this));
        $("#multi_search").on("click", this.delete.bind(this))
        // $("#multi_search li").on("keyup", this.update.bind(this));
      },
      create: function(key) {
        event.preventDefault();
          var todo = new Todo($('#d3_1_search').val(), index)
          index++
          $('#d3_1_search').val("")
          TodoList.add(todo)
      },
      update: function(key){
        event.preventDefault();
        if(key.keyCode == 13 || key.keyCode == 9) {
          var index = $(key.target).parent().find(".index").text()
          var text = $(key.target).val()
          TodoList.update(index, text)
        }
      },
      delete: function(key){
        if ($(key.target).hasClass("delete"))  {
          TodoList.delete($(key.target).next().text())
        }
      }
    }

    var TodoView =  {
      update: function(todos) {
        updateSearch(todos)
        $('#multi_search li').remove();
        todos.forEach(function(todo) {
          $('#multi_search').append('<li style="background-color:' + todo.color + '"><input  class="form-control" value="' + todo.text + '"><span class="delete">&times;</span><span class="index">' + todo.index + '</span></li>')
        })
      }
    }

    function Todo(text, index) {
      this.text = text;
      this.index = index;
      this.complete = false;
      this.color = "#6BAED6";
    }

    Todo.prototype = {
      finish : function() {
        this.complete = true;
      },
      unfinish : function() {
        this.complete = false;
      }
    }

    var TodoList = {
      todos : [],
      add   : function(todo) {
        this.todos.push(todo)
        TodoView.update(this.todos)
      },
      update : function(index,text) {
        this.todos = _.map(this.todos, function(todo){ if (todo.index == index) {
                                                              todo.text = text
                                                              return todo
                                                            } else {
                                                              return todo
                                                            }
      });
        TodoView.update(this.todos)
      },
      delete : function(index) {
        this.todos = _.reject(this.todos, function(todo){ return todo.index == index; })
        TodoView.update(this.todos)
      }
    }

    var controller = new TodoController();
    controller.bindEvents();
    var showErrorMessage = function() {
      $("#multi_search").append('<li id="d3_1_error">Hmm, Please Try Again</li>')
    }
    var validate = function() {
      event.preventDefault();
      $.get("/search", {"list" : [$('#d3_1_search').val()]}).done(controller.create).fail(showErrorMessage)
    }

    $("#d3_1 form").submit(validate);


  //d3 portion
  var w = 500;
  var h = 500;
  var r = Math.min(w,h)/2;
  var color = d3.scale.category20c();
  var root = {};
  var colorStore = [];

  var updateSearch = function(todos) {
    d3.select("#charts svg").remove();
    d3.selectAll("#legend tr").remove();
    $(".rec").hide();
    $("#reclist").empty();
    colorStore = [];
    todos = _.map(todos, function(todo){ return todo["text"]})
    if (todos.length > 0) {
      $.get("/search", {"list" : todos}, function(result) {
        root = result;
      }, "json").done(dataDriven);
      $.get("/top", {"list" : todos}, function(result) {
        $(".rec").fadeIn(500);
        _.map(result, function(res) { $("#reclist").append("<li>" + res[1] + ", " +res[0] + "</li>") })
      })
    }
  }

  var dataDriven = function() {
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
    .style("position", "absolute")
    .style("visibility","hidden");


  var path = svg.datum(root).selectAll("g")
      .data(partition.nodes)
      .enter().append("g")

   var donut = path.append("path")
        .attr("class", function(d) {if (d.data) {return d.title + " "+ Math.floor(d.data * 100) + "%"} else { return d.title}})
        .attr("d", 1)
        .attr("display", function(d) {return d.depth ? null : "none" ;})
        .attr("fill", function(d) {if(d.children) { colorStore.push({"category":(d.title), "color":color(d.title)}); return color(d.title);} else {return color(d.parent.title)};})
        .style("stroke", "#fff")
        .on("mouseover", function(d) {return title.text(this.className.animVal).style("visibility","visible");})
        .on("mousemove", function(d) {return title.style("top", (event.pageY-10) + "px").style("left", (event.pageX+10)+ "px");})
        .on("mouseout", function(d) {return title.style("visibility", "hidden")})
        .call(transition, arc);


        function transition(element, arc) {
            element.transition().delay(10).duration(500).attr("d", arc)
        }

  colorStore.shift(1)

  var legend = d3.select("#legend").selectAll("tr").data(colorStore)
      .enter().append("tr");

    legend.selectAll("td")
      .data(function(d) {return [d3.values(d)[0]]})
      .enter().append("td")
      .text(function(d){return d});

    legend.selectAll("td")
      .data(function(d) {return d3.values(d)})
      .enter().append("td")
      .style("background-color", function(d) {return d;})
      .attr("width", "20px")
      .attr("hegith", "5px");

  }
})
