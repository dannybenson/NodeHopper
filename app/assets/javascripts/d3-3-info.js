$(function(){
      var index = 0
      function TodoController() {
      this.index = 0
    }

    TodoController.prototype = {
      bindEvents : function() {
        // $("#d3_3 form").submit(this.create.bind(this));
        $("#multi_search_3").on("click", this.delete.bind(this))
        // $("#multi_search_3 li").on("keyup", this.update.bind(this));
      },
      create: function(key) {
        event.preventDefault();
          var todo = new Todo($('#d33').val(), index)
          index++
          $('#d33').val("")
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
        $('#multi_search_3 li').remove();
        todos.forEach(function(todo) {
          $('#multi_search_3').append('<li style="background-color:' + todo.color + '"><input  class="form-control" value="' + todo.text + '"><span class="delete">&times;</span><span class="index">' + todo.index + '</span></li>')
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
        // if (this.todos.length) {
        this.todos.push(todo)
        TodoView.update(this.todos)

      // }
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

    var root;
    var drawVenn = function() {venn.drawD3Diagram(venn.venn(root.set, root.overlap), 700, 700) }

    var showErrorMessage = function() {
      $("#multi_search_3").append('<li id="d3_1_error">Hmm, Please Try Again</li>')
    }

    var validate = function() {
      event.preventDefault();
      console.log("validate was called")
      // $.get("/search", {"list" : [$('#d3_1_search').val()]}).done(controller.create).fail(showErrorMessage)
      $.get("/d3_3", {"list" : [$('#d33').val()]}, "json").done(controller.create).fail(showErrorMessage)
    }


    $("#d3_3 form").submit(validate);

  var updateSearch = function(todos) {
    d3.select("#d3-3-chart svg").remove();
    todos = _.map(todos, function(todo){ return todo["text"]})
    $.get("/d3_3", {"list" : todos}, function(result) {
      root = result;
    }, "json").done(drawVenn);
  }

})
