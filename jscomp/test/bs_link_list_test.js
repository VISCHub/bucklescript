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

Mt.from_pair_suites("bs_link_list_test.ml", suites[0]);

var N = 0;

var A = 0;

exports.suites  = suites;
exports.test_id = test_id;
exports.eq      = eq;
exports.b       = b;
exports.N       = N;
exports.A       = A;
/* u Not a pure module */
