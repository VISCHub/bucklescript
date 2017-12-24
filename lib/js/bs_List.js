'use strict';


function headOpt(x) {
  if (x) {
    return /* Some */[x[0]];
  } else {
    return /* None */0;
  }
}

function tailOpt(x) {
  if (x) {
    return /* Some */[x[1]];
  } else {
    return /* None */0;
  }
}

function nthOpt(x, n) {
  if (n < 0) {
    return /* None */0;
  } else {
    var _x = x;
    var _n = n;
    while(true) {
      var n$1 = _n;
      var x$1 = _x;
      if (x$1) {
        if (n$1) {
          _n = n$1 - 1 | 0;
          _x = x$1[1];
          continue ;
          
        } else {
          return /* Some */[x$1[0]];
        }
      } else {
        return /* None */0;
      }
    };
  }
}

function nthAssert(x, n) {
  if (n < 0) {
    throw new Error("nthAssert");
  } else {
    var _x = x;
    var _n = n;
    while(true) {
      var n$1 = _n;
      var x$1 = _x;
      if (x$1) {
        if (n$1) {
          _n = n$1 - 1 | 0;
          _x = x$1[1];
          continue ;
          
        } else {
          return x$1[0];
        }
      } else {
        throw new Error("nthAssert");
      }
    };
  }
}

function partitionAux(p, _cell, _precX, _precY) {
  while(true) {
    var precY = _precY;
    var precX = _precX;
    var cell = _cell;
    if (cell) {
      var t = cell[1];
      var h = cell[0];
      var next = /* :: */[
        h,
        /* [] */0
      ];
      if (p(h)) {
        precX[1] = next;
        _precX = next;
        _cell = t;
        continue ;
        
      } else {
        precY[1] = next;
        _precY = next;
        _cell = t;
        continue ;
        
      }
    } else {
      return /* () */0;
    }
  };
}

function splitAux(_cell, _precX, _precY) {
  while(true) {
    var precY = _precY;
    var precX = _precX;
    var cell = _cell;
    if (cell) {
      var match = cell[0];
      var nextA = /* :: */[
        match[0],
        /* [] */0
      ];
      var nextB = /* :: */[
        match[1],
        /* [] */0
      ];
      precX[1] = nextA;
      precY[1] = nextB;
      _precY = nextB;
      _precX = nextA;
      _cell = cell[1];
      continue ;
      
    } else {
      return /* () */0;
    }
  };
}

function copyAuxCont(_cellX, _prec) {
  while(true) {
    var prec = _prec;
    var cellX = _cellX;
    if (cellX) {
      var next = /* :: */[
        cellX[0],
        /* [] */0
      ];
      prec[1] = next;
      _prec = next;
      _cellX = cellX[1];
      continue ;
      
    } else {
      return prec;
    }
  };
}

function copyAuxWitFilter(f, _cellX, _prec) {
  while(true) {
    var prec = _prec;
    var cellX = _cellX;
    if (cellX) {
      var t = cellX[1];
      var h = cellX[0];
      if (f(h)) {
        var next = /* :: */[
          h,
          /* [] */0
        ];
        prec[1] = next;
        _prec = next;
        _cellX = t;
        continue ;
        
      } else {
        _cellX = t;
        continue ;
        
      }
    } else {
      prec[1] = /* [] */0;
      return /* () */0;
    }
  };
}

function copyAuxWithMap(f, _cellX, _prec) {
  while(true) {
    var prec = _prec;
    var cellX = _cellX;
    if (cellX) {
      var next = /* :: */[
        f(cellX[0]),
        /* [] */0
      ];
      prec[1] = next;
      _prec = next;
      _cellX = cellX[1];
      continue ;
      
    } else {
      prec[1] = /* [] */0;
      return /* () */0;
    }
  };
}

function zipAux(_cellX, _cellY, _prec) {
  while(true) {
    var prec = _prec;
    var cellY = _cellY;
    var cellX = _cellX;
    if (cellX) {
      if (cellY) {
        var next = /* :: */[
          /* tuple */[
            cellX[0],
            cellY[0]
          ],
          /* [] */0
        ];
        prec[1] = next;
        _prec = next;
        _cellY = cellY[1];
        _cellX = cellX[1];
        continue ;
        
      } else {
        return /* () */0;
      }
    } else {
      return /* () */0;
    }
  };
}

function copyAuxWithMap2(f, _cellX, _cellY, _prec) {
  while(true) {
    var prec = _prec;
    var cellY = _cellY;
    var cellX = _cellX;
    if (cellX) {
      if (cellY) {
        var next = /* :: */[
          f(cellX[0], cellY[0]),
          /* [] */0
        ];
        prec[1] = next;
        _prec = next;
        _cellY = cellY[1];
        _cellX = cellX[1];
        continue ;
        
      } else {
        prec[1] = /* [] */0;
        return /* () */0;
      }
    } else {
      prec[1] = /* [] */0;
      return /* () */0;
    }
  };
}

function copyAuxWithMapI(f, _i, _cellX, _prec) {
  while(true) {
    var prec = _prec;
    var cellX = _cellX;
    var i = _i;
    if (cellX) {
      var next = /* :: */[
        f(i, cellX[0]),
        /* [] */0
      ];
      prec[1] = next;
      _prec = next;
      _cellX = cellX[1];
      _i = i + 1 | 0;
      continue ;
      
    } else {
      prec[1] = /* [] */0;
      return /* () */0;
    }
  };
}

function takeAux(_n, _cell, _prec) {
  while(true) {
    var prec = _prec;
    var cell = _cell;
    var n = _n;
    if (n) {
      if (cell) {
        var cell$1 = /* :: */[
          cell[0],
          /* [] */0
        ];
        prec[1] = cell$1;
        _prec = cell$1;
        _cell = cell[1];
        _n = n - 1 | 0;
        continue ;
        
      } else {
        return /* false */0;
      }
    } else {
      return /* true */1;
    }
  };
}

function splitAtAux(_n, _cell, _prec) {
  while(true) {
    var prec = _prec;
    var cell = _cell;
    var n = _n;
    if (n) {
      if (cell) {
        var cell$1 = /* :: */[
          cell[0],
          /* [] */0
        ];
        prec[1] = cell$1;
        _prec = cell$1;
        _cell = cell[1];
        _n = n - 1 | 0;
        continue ;
        
      } else {
        return /* None */0;
      }
    } else {
      return /* Some */[cell];
    }
  };
}

function takeOpt(lst, n) {
  if (n < 0) {
    return /* None */0;
  } else if (n) {
    if (lst) {
      var cell = /* :: */[
        lst[0],
        /* [] */0
      ];
      var has = takeAux(n - 1 | 0, lst[1], cell);
      if (has) {
        return /* Some */[cell];
      } else {
        return /* None */0;
      }
    } else {
      return /* None */0;
    }
  } else {
    return /* Some */[/* [] */0];
  }
}

function dropOpt(lst, n) {
  if (n < 0) {
    return /* None */0;
  } else {
    var _l = lst;
    var _n = n;
    while(true) {
      var n$1 = _n;
      var l = _l;
      if (n$1) {
        if (l) {
          _n = n$1 - 1 | 0;
          _l = l[1];
          continue ;
          
        } else {
          return /* None */0;
        }
      } else {
        return /* Some */[l];
      }
    };
  }
}

function splitAtOpt(lst, n) {
  if (n < 0) {
    return /* None */0;
  } else if (n) {
    if (lst) {
      var cell = /* :: */[
        lst[0],
        /* [] */0
      ];
      var rest = splitAtAux(n - 1 | 0, lst[1], cell);
      if (rest) {
        return /* Some */[/* tuple */[
                  cell,
                  rest[0]
                ]];
      } else {
        return /* None */0;
      }
    } else {
      return /* None */0;
    }
  } else {
    return /* Some */[/* tuple */[
              /* [] */0,
              lst
            ]];
  }
}

function append(xs, ys) {
  if (xs) {
    var cell = /* :: */[
      xs[0],
      /* [] */0
    ];
    copyAuxCont(xs[1], cell)[1] = ys;
    return cell;
  } else {
    return ys;
  }
}

function map(xs, f) {
  if (xs) {
    var cell = /* :: */[
      f(xs[0]),
      /* [] */0
    ];
    copyAuxWithMap(f, xs[1], cell);
    return cell;
  } else {
    return /* [] */0;
  }
}

function map2(f, l1, l2) {
  if (l1) {
    if (l2) {
      var cell = /* :: */[
        f(l1[0], l2[0]),
        /* [] */0
      ];
      copyAuxWithMap2(f, l1[1], l2[1], cell);
      return cell;
    } else {
      return /* [] */0;
    }
  } else {
    return /* [] */0;
  }
}

function mapi(f, param) {
  if (param) {
    var cell = /* :: */[
      f(0, param[0]),
      /* [] */0
    ];
    copyAuxWithMapI(f, 1, param[1], cell);
    return cell;
  } else {
    return /* [] */0;
  }
}

function init(n, f) {
  if (n < 0) {
    throw new Error("Invalid_argument");
  } else if (n) {
    var headX = /* :: */[
      f(0),
      /* [] */0
    ];
    var cur = headX;
    var i = 1;
    while(i < n) {
      var v = /* :: */[
        f(i),
        /* [] */0
      ];
      cur[1] = v;
      cur = v;
      i = i + 1 | 0;
    };
    return headX;
  } else {
    return /* [] */0;
  }
}

function length(xs) {
  var _x = xs;
  var _acc = 0;
  while(true) {
    var acc = _acc;
    var x = _x;
    if (x) {
      _acc = acc + 1 | 0;
      _x = x[1];
      continue ;
      
    } else {
      return acc;
    }
  };
}

function fillAux(arr, _i, _x) {
  while(true) {
    var x = _x;
    var i = _i;
    if (x) {
      arr[i] = x[0];
      _x = x[1];
      _i = i + 1 | 0;
      continue ;
      
    } else {
      return /* () */0;
    }
  };
}

function toArray(x) {
  var len = length(x);
  var arr = new Array(len);
  fillAux(arr, 0, x);
  return arr;
}

function revAppend(_l1, _l2) {
  while(true) {
    var l2 = _l2;
    var l1 = _l1;
    if (l1) {
      _l2 = /* :: */[
        l1[0],
        l2
      ];
      _l1 = l1[1];
      continue ;
      
    } else {
      return l2;
    }
  };
}

function rev(l) {
  return revAppend(l, /* [] */0);
}

function flattenAux(_prec, _xs) {
  while(true) {
    var xs = _xs;
    var prec = _prec;
    if (xs) {
      _xs = xs[1];
      _prec = copyAuxCont(xs[0], prec);
      continue ;
      
    } else {
      prec[1] = /* [] */0;
      return /* () */0;
    }
  };
}

function flatten(_xs) {
  while(true) {
    var xs = _xs;
    if (xs) {
      var match = xs[0];
      if (match) {
        var cell = /* :: */[
          match[0],
          /* [] */0
        ];
        flattenAux(copyAuxCont(match[1], cell), xs[1]);
        return cell;
      } else {
        _xs = xs[1];
        continue ;
        
      }
    } else {
      return /* [] */0;
    }
  };
}

function mapRev(f, l) {
  var f$1 = f;
  var _accu = /* [] */0;
  var _xs = l;
  while(true) {
    var xs = _xs;
    var accu = _accu;
    if (xs) {
      _xs = xs[1];
      _accu = /* :: */[
        f$1(xs[0]),
        accu
      ];
      continue ;
      
    } else {
      return accu;
    }
  };
}

function iter(f, _param) {
  while(true) {
    var param = _param;
    if (param) {
      f(param[0]);
      _param = param[1];
      continue ;
      
    } else {
      return /* () */0;
    }
  };
}

function iteri(f, l) {
  var _i = 0;
  var f$1 = f;
  var _param = l;
  while(true) {
    var param = _param;
    var i = _i;
    if (param) {
      f$1(i, param[0]);
      _param = param[1];
      _i = i + 1 | 0;
      continue ;
      
    } else {
      return /* () */0;
    }
  };
}

function foldLeft(f, _accu, _l) {
  while(true) {
    var l = _l;
    var accu = _accu;
    if (l) {
      _l = l[1];
      _accu = f(accu, l[0]);
      continue ;
      
    } else {
      return accu;
    }
  };
}

function foldRight(f, l, accu) {
  if (l) {
    return f(l[0], foldRight(f, l[1], accu));
  } else {
    return accu;
  }
}

function mapRev2(f, l1, l2) {
  var f$1 = f;
  var _accu = /* [] */0;
  var _l1 = l1;
  var _l2 = l2;
  while(true) {
    var l2$1 = _l2;
    var l1$1 = _l1;
    var accu = _accu;
    if (l1$1) {
      if (l2$1) {
        _l2 = l2$1[1];
        _l1 = l1$1[1];
        _accu = /* :: */[
          f$1(l1$1[0], l2$1[0]),
          accu
        ];
        continue ;
        
      } else {
        return /* [] */0;
      }
    } else {
      return /* [] */0;
    }
  };
}

function iter2(f, _l1, _l2) {
  while(true) {
    var l2 = _l2;
    var l1 = _l1;
    if (l1) {
      if (l2) {
        f(l1[0], l2[0]);
        _l2 = l2[1];
        _l1 = l1[1];
        continue ;
        
      } else {
        return /* () */0;
      }
    } else {
      return /* () */0;
    }
  };
}

function foldLeft2(f, _accu, _l1, _l2) {
  while(true) {
    var l2 = _l2;
    var l1 = _l1;
    var accu = _accu;
    if (l1) {
      if (l2) {
        _l2 = l2[1];
        _l1 = l1[1];
        _accu = f(accu, l1[0], l2[0]);
        continue ;
        
      } else {
        return accu;
      }
    } else {
      return accu;
    }
  };
}

function foldRight2(f, l1, l2, accu) {
  if (l1 && l2) {
    return f(l1[0], l2[0], foldRight2(f, l1[1], l2[1], accu));
  } else {
    return accu;
  }
}

function forAll(p, _param) {
  while(true) {
    var param = _param;
    if (param) {
      if (p(param[0])) {
        _param = param[1];
        continue ;
        
      } else {
        return /* false */0;
      }
    } else {
      return /* true */1;
    }
  };
}

function exists(p, _param) {
  while(true) {
    var param = _param;
    if (param) {
      if (p(param[0])) {
        return /* true */1;
      } else {
        _param = param[1];
        continue ;
        
      }
    } else {
      return /* false */0;
    }
  };
}

function forAll2(p, _l1, _l2) {
  while(true) {
    var l2 = _l2;
    var l1 = _l1;
    if (l1) {
      if (l2) {
        if (p(l1[0], l2[0])) {
          _l2 = l2[1];
          _l1 = l1[1];
          continue ;
          
        } else {
          return /* false */0;
        }
      } else {
        return /* true */1;
      }
    } else {
      return /* true */1;
    }
  };
}

function exists2(p, _l1, _l2) {
  while(true) {
    var l2 = _l2;
    var l1 = _l1;
    if (l1) {
      if (l2) {
        if (p(l1[0], l2[0])) {
          return /* true */1;
        } else {
          _l2 = l2[1];
          _l1 = l1[1];
          continue ;
          
        }
      } else {
        return /* false */0;
      }
    } else {
      return /* false */0;
    }
  };
}

function mem(eq, x, _param) {
  while(true) {
    var param = _param;
    if (param) {
      if (eq(param[0], x)) {
        return /* true */1;
      } else {
        _param = param[1];
        continue ;
        
      }
    } else {
      return /* false */0;
    }
  };
}

function memq(x, _param) {
  while(true) {
    var param = _param;
    if (param) {
      if (param[0] === x) {
        return /* true */1;
      } else {
        _param = param[1];
        continue ;
        
      }
    } else {
      return /* false */0;
    }
  };
}

function assocOpt(eq, x, _param) {
  while(true) {
    var param = _param;
    if (param) {
      var match = param[0];
      if (eq(match[0], x)) {
        return /* Some */[match[1]];
      } else {
        _param = param[1];
        continue ;
        
      }
    } else {
      return /* None */0;
    }
  };
}

function assqOpt(x, _param) {
  while(true) {
    var param = _param;
    if (param) {
      var match = param[0];
      if (match[0] === x) {
        return /* Some */[match[1]];
      } else {
        _param = param[1];
        continue ;
        
      }
    } else {
      return /* None */0;
    }
  };
}

function memAssoc(eq, x, _param) {
  while(true) {
    var param = _param;
    if (param) {
      if (eq(param[0][0], x)) {
        return /* true */1;
      } else {
        _param = param[1];
        continue ;
        
      }
    } else {
      return /* false */0;
    }
  };
}

function memAssq(x, _param) {
  while(true) {
    var param = _param;
    if (param) {
      if (param[0][0] === x) {
        return /* true */1;
      } else {
        _param = param[1];
        continue ;
        
      }
    } else {
      return /* false */0;
    }
  };
}

function removeAssoc(eq, x, param) {
  if (param) {
    var l = param[1];
    var pair = param[0];
    if (eq(pair[0], x)) {
      return l;
    } else {
      return /* :: */[
              pair,
              removeAssoc(eq, x, l)
            ];
    }
  } else {
    return /* [] */0;
  }
}

function removeAssq(x, param) {
  if (param) {
    var l = param[1];
    var pair = param[0];
    if (pair[0] === x) {
      return l;
    } else {
      return /* :: */[
              pair,
              removeAssq(x, l)
            ];
    }
  } else {
    return /* [] */0;
  }
}

function findOpt(p, _param) {
  while(true) {
    var param = _param;
    if (param) {
      var x = param[0];
      if (p(x)) {
        return /* Some */[x];
      } else {
        _param = param[1];
        continue ;
        
      }
    } else {
      return /* None */0;
    }
  };
}

function filter(p, _xs) {
  while(true) {
    var xs = _xs;
    if (xs) {
      var t = xs[1];
      var h = xs[0];
      if (p(h)) {
        var cell = /* :: */[
          h,
          /* [] */0
        ];
        copyAuxWitFilter(p, t, cell);
        return cell;
      } else {
        _xs = t;
        continue ;
        
      }
    } else {
      return /* [] */0;
    }
  };
}

function partition(p, l) {
  if (l) {
    var h = l[0];
    var nextX = /* :: */[
      h,
      /* [] */0
    ];
    var nextY = /* :: */[
      h,
      /* [] */0
    ];
    var b = p(h);
    partitionAux(p, l[1], nextX, nextY);
    if (b) {
      return /* tuple */[
              nextX,
              nextY[1]
            ];
    } else {
      return /* tuple */[
              nextX[1],
              nextY
            ];
    }
  } else {
    return /* tuple */[
            /* [] */0,
            /* [] */0
          ];
  }
}

function unzip(xs) {
  if (xs) {
    var match = xs[0];
    var cellX = /* :: */[
      match[0],
      /* [] */0
    ];
    var cellY = /* :: */[
      match[1],
      /* [] */0
    ];
    splitAux(xs[1], cellX, cellY);
    return /* tuple */[
            cellX,
            cellY
          ];
  } else {
    return /* tuple */[
            /* [] */0,
            /* [] */0
          ];
  }
}

function zip(l1, l2) {
  if (l1) {
    if (l2) {
      var cell = /* :: */[
        /* tuple */[
          l1[0],
          l2[0]
        ],
        /* [] */0
      ];
      zipAux(l1[1], l2[1], cell);
      return cell;
    } else {
      return /* [] */0;
    }
  } else {
    return /* [] */0;
  }
}

exports.headOpt     = headOpt;
exports.tailOpt     = tailOpt;
exports.nthOpt      = nthOpt;
exports.nthAssert   = nthAssert;
exports.dropOpt     = dropOpt;
exports.takeOpt     = takeOpt;
exports.splitAtOpt  = splitAtOpt;
exports.append      = append;
exports.map         = map;
exports.map2        = map2;
exports.mapi        = mapi;
exports.init        = init;
exports.length      = length;
exports.toArray     = toArray;
exports.revAppend   = revAppend;
exports.rev         = rev;
exports.flatten     = flatten;
exports.mapRev      = mapRev;
exports.iter        = iter;
exports.iteri       = iteri;
exports.foldLeft    = foldLeft;
exports.foldRight   = foldRight;
exports.mapRev2     = mapRev2;
exports.iter2       = iter2;
exports.foldLeft2   = foldLeft2;
exports.foldRight2  = foldRight2;
exports.forAll      = forAll;
exports.exists      = exists;
exports.forAll2     = forAll2;
exports.exists2     = exists2;
exports.mem         = mem;
exports.memq        = memq;
exports.assocOpt    = assocOpt;
exports.assqOpt     = assqOpt;
exports.memAssoc    = memAssoc;
exports.memAssq     = memAssq;
exports.removeAssoc = removeAssoc;
exports.removeAssq  = removeAssq;
exports.findOpt     = findOpt;
exports.filter      = filter;
exports.partition   = partition;
exports.unzip       = unzip;
exports.zip         = zip;
/* No side effect */
