var root = { "set": [{label : 'SE', size : 28}, {label : 'Treat', size: 35}, {label : 'snow', size: 20}],
    "overlap": [{sets : [0,1], size:2},
          {sets : [0,2], size:3},
          {sets : [1,2], size: 10},
          {sets : [0,1,2], size: 10}
                       ]};

venn.drawD3Diagram(venn.venn(root.set, root.overlap), 300,


