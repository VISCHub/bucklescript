'use strict';

var Mt         = require("./mt.js");
var Block      = require("../../lib/js/block.js");
var Bs_List    = require("../../lib/js/bs_List.js");
var Bs_Array   = require("../../lib/js/bs_Array.js");
var Caml_int32 = require("../../lib/js/caml_int32.js");

var suites = [/* [] */0];

var test_id = [0];

function eq(loc, x, y) {
  test_id[0] = test_id[0] + 1 | 0;
  suites[0] = /* :: */[
    /* tuple */[
      loc + (" id " + test_id[0]),
      (function () {
          return /* Eq */Block.__(0, [
                    x,
                    y
                  ]);
        })
    ],
    suites[0]
  ];
  return /* () */0;
}

function b(loc, x) {
  test_id[0] = test_id[0] + 1 | 0;
  suites[0] = /* :: */[
    /* tuple */[
      loc + (" id " + test_id[0]),
      (function () {
          return /* Ok */Block.__(4, [x]);
        })
    ],
    suites[0]
  ];
  return /* () */0;
}

var u = Bs_List.init(5, (function (i) {
        return Caml_int32.imul(i, i);
      }));

function f(i) {
  return eq("File \"bs_link_list_test.ml\", line 23, characters 7-14", Bs_List.nthAssert(u, i), Caml_int32.imul(i, i));
}

for(var i = 0; i <= 4; ++i){
  f(i);
}

eq("File \"bs_link_list_test.ml\", line 27, characters 5-12", Bs_List.map(u, (function (i) {
            return i + 1 | 0;
          })), /* :: */[
      1,
      /* :: */[
        2,
        /* :: */[
          5,
          /* :: */[
            10,
            /* :: */[
              17,
              /* [] */0
            ]
          ]
        ]
      ]
    ]);

eq("File \"bs_link_list_test.ml\", line 30, characters 5-12", Bs_List.flatten(/* :: */[
          /* :: */[
            1,
            /* [] */0
          ],
          /* :: */[
            /* :: */[
              2,
              /* [] */0
            ],
            /* :: */[
              /* :: */[
                3,
                /* [] */0
              ],
              /* :: */[
                /* [] */0,
                /* :: */[
                  Bs_List.init(4, (function (i) {
                          return i;
                        })),
                  /* [] */0
                ]
              ]
            ]
          ]
        ]), /* :: */[
      1,
      /* :: */[
        2,
        /* :: */[
          3,
          /* :: */[
            0,
            /* :: */[
              1,
              /* :: */[
                2,
                /* :: */[
                  3,
                  /* [] */0
                ]
              ]
            ]
          ]
        ]
      ]
    ]);

eq("File \"bs_link_list_test.ml\", line 37, characters 5-12", Bs_List.toArray(Bs_List.append(Bs_List.init(100, (function (i) {
                    return i;
                  })), Bs_List.init(100, (function (i) {
                    return i;
                  })))), Bs_Array.append(Bs_Array.init(100, (function (i) {
                return i;
              })), Bs_Array.init(100, (function (i) {
                return i;
              }))));

eq("ZIP", Bs_List.zip(/* :: */[
          1,
          /* :: */[
            2,
            /* :: */[
              3,
              /* [] */0
            ]
          ]
        ], /* :: */[
          3,
          /* :: */[
            4,
            /* [] */0
          ]
        ]), /* :: */[
      /* tuple */[
        1,
        3
      ],
      /* :: */[
        /* tuple */[
          2,
          4
        ],
        /* [] */0
      ]
    ]);

eq("ZIP", Bs_List.zip(/* [] */0, /* :: */[
          1,
          /* [] */0
        ]), /* [] */0);

eq("ZIP", Bs_List.zip(/* [] */0, /* [] */0), /* [] */0);

eq("ZIP", Bs_List.zip(/* :: */[
          1,
          /* :: */[
            2,
            /* :: */[
              3,
              /* [] */0
            ]
          ]
        ], /* [] */0), /* [] */0);

eq("ZIP", Bs_List.zip(/* :: */[
          1,
          /* :: */[
            2,
            /* :: */[
              3,
              /* [] */0
            ]
          ]
        ], /* :: */[
          2,
          /* :: */[
            3,
            /* :: */[
              4,
              /* [] */0
            ]
          ]
        ]), /* :: */[
      /* tuple */[
        1,
        2
      ],
      /* :: */[
        /* tuple */[
          2,
          3
        ],
        /* :: */[
          /* tuple */[
            3,
            4
          ],
          /* [] */0
        ]
      ]
    ]);

function mod2(x) {
  return +(x % 2 === 0);
}

eq("PARTITION", Bs_List.partition(mod2, /* :: */[
          1,
          /* :: */[
            2,
            /* :: */[
              3,
              /* :: */[
                2,
                /* :: */[
                  3,
                  /* :: */[
                    4,
                    /* [] */0
                  ]
                ]
              ]
            ]
          ]
        ]), /* tuple */[
      /* :: */[
        2,
        /* :: */[
          2,
          /* :: */[
            4,
            /* [] */0
          ]
        ]
      ],
      /* :: */[
        1,
        /* :: */[
          3,
          /* :: */[
            3,
            /* [] */0
          ]
        ]
      ]
    ]);

eq("PARTITION", Bs_List.partition(mod2, /* :: */[
          2,
          /* :: */[
            2,
            /* :: */[
              2,
              /* :: */[
                4,
                /* [] */0
              ]
            ]
          ]
        ]), /* tuple */[
      /* :: */[
        2,
        /* :: */[
          2,
          /* :: */[
            2,
            /* :: */[
              4,
              /* [] */0
            ]
          ]
        ]
      ],
      /* [] */0
    ]);

eq("PARTITION", Bs_List.partition((function (x) {
            return 1 - mod2(x);
          }), /* :: */[
          2,
          /* :: */[
            2,
            /* :: */[
              2,
              /* :: */[
                4,
                /* [] */0
              ]
            ]
          ]
        ]), /* tuple */[
      /* [] */0,
      /* :: */[
        2,
        /* :: */[
          2,
          /* :: */[
            2,
            /* :: */[
              4,
              /* [] */0
            ]
          ]
        ]
      ]
    ]);

eq("SPLIT", Bs_List.split(/* [] */0), /* tuple */[
      /* [] */0,
      /* [] */0
    ]);

eq("SPLIT", Bs_List.split(/* :: */[
          /* tuple */[
            1,
            2
          ],
          /* [] */0
        ]), /* tuple */[
      /* :: */[
        1,
        /* [] */0
      ],
      /* :: */[
        2,
        /* [] */0
      ]
    ]);

eq("SPLIT", Bs_List.split(/* :: */[
          /* tuple */[
            1,
            2
          ],
          /* :: */[
            /* tuple */[
              3,
              4
            ],
            /* [] */0
          ]
        ]), /* tuple */[
      /* :: */[
        1,
        /* :: */[
          3,
          /* [] */0
        ]
      ],
      /* :: */[
        2,
        /* :: */[
          4,
          /* [] */0
        ]
      ]
    ]);

eq("FILTER", Bs_List.filter(mod2, /* :: */[
          1,
          /* :: */[
            2,
            /* :: */[
              3,
              /* :: */[
                4,
                /* [] */0
              ]
            ]
          ]
        ]), /* :: */[
      2,
      /* :: */[
        4,
        /* [] */0
      ]
    ]);

eq("FILTER", Bs_List.filter(mod2, /* :: */[
          1,
          /* :: */[
            3,
            /* :: */[
              41,
              /* [] */0
            ]
          ]
        ]), /* [] */0);

eq("FILTER", Bs_List.filter(mod2, /* [] */0), /* [] */0);

eq("FILTER", Bs_List.filter(mod2, /* :: */[
          2,
          /* :: */[
            2,
            /* :: */[
              2,
              /* :: */[
                4,
                /* :: */[
                  6,
                  /* [] */0
                ]
              ]
            ]
          ]
        ]), /* :: */[
      2,
      /* :: */[
        2,
        /* :: */[
          2,
          /* :: */[
            4,
            /* :: */[
              6,
              /* [] */0
            ]
          ]
        ]
      ]
    ]);

function id(x) {
  return x;
}

eq("MAP", Bs_List.map(Bs_List.init(5, id), (function (x) {
            return (x << 1);
          })), /* :: */[
      0,
      /* :: */[
        2,
        /* :: */[
          4,
          /* :: */[
            6,
            /* :: */[
              8,
              /* [] */0
            ]
          ]
        ]
      ]
    ]);

eq("MAP", Bs_List.map(/* [] */0, id), /* [] */0);

eq("MAP", Bs_List.map(/* :: */[
          1,
          /* [] */0
        ], (function (x) {
            return -x | 0;
          })), /* :: */[
      -1,
      /* [] */0
    ]);

function add(a, b) {
  return a + b | 0;
}

var a = Bs_List.init(10, id);

var b$1 = Bs_List.init(10, id);

var c = Bs_List.init(8, id);

var d = Bs_List.init(10, (function (x) {
        return (x << 1);
      }));

eq("MAP2", Bs_List.map2(add, a, b$1), d);

eq("MAP2", Bs_List.map2(add, /* [] */0, /* :: */[
          1,
          /* [] */0
        ]), /* [] */0);

eq("MAP2", Bs_List.map2(add, /* :: */[
          1,
          /* [] */0
        ], /* [] */0), /* [] */0);

eq("MAP2", Bs_List.map2(add, /* [] */0, /* [] */0), /* [] */0);

eq("MAP2", Bs_List.map2(add, a, b$1), Bs_List.append(Bs_List.map(c, (function (x) {
                return (x << 1);
              })), /* :: */[
          16,
          /* :: */[
            18,
            /* [] */0
          ]
        ]));

Mt.from_pair_suites("bs_link_list_test.ml", suites[0]);

var N = 0;

var A = 0;

exports.suites  = suites;
exports.test_id = test_id;
exports.eq      = eq;
exports.b       = b;
exports.N       = N;
exports.A       = A;
exports.mod2    = mod2;
exports.id      = id;
exports.add     = add;
/* u Not a pure module */
