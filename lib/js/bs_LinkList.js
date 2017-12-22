'use strict';

var Js_primitive = require("./js_primitive.js");

function toOpt(prim) {
  if (prim === null) {
    return /* None */0;
  } else {
    return [prim];
  }
}

function $$return(prim) {
  return prim;
}

var empty = null;

function headOpt(x) {
  return Js_primitive.null_to_opt(x.data);
}

function tailOpt(x) {
  var match = x.data;
  if (match !== null) {
    return Js_primitive.null_to_opt(match.tail);
  } else {
    return /* None */0;
  }
}

function lengthCellAux(_x, _acc) {
  while(true) {
    var acc = _acc;
    var x = _x;
    if (x !== null) {
      _acc = acc + 1 | 0;
      _x = x.tail;
      continue ;
      
    } else {
      return acc;
    }
  };
}

function checkInvariant(x) {
  if (x.length !== lengthCellAux(x.data, 0)) {
    throw new Error("File \"bs_LinkList.ml\", line 37, characters 4-10");
  } else {
    return 0;
  }
}

function nextAuxAssert(_opt_cell, _n) {
  while(true) {
    var n = _n;
    var opt_cell = _opt_cell;
    if (n) {
      _n = n - 1 | 0;
      _opt_cell = opt_cell.tail;
      continue ;
      
    } else {
      return opt_cell.head;
    }
  };
}

function nthOpt(x, n) {
  if (n < 0 || n >= x.length) {
    return /* None */0;
  } else {
    return /* Some */[nextAuxAssert(x.data, n)];
  }
}

function nthAssert(x, n) {
  if (n < 0) {
    throw new Error("Neg");
  } else {
    return nextAuxAssert(x.data, n);
  }
}

function copyAux(_cellX, _prec) {
  while(true) {
    var prec = _prec;
    var cellX = _cellX;
    if (cellX !== null) {
      var h = cellX.head;
      var t = cellX.tail;
      var next = {
        head: h,
        tail: empty
      };
      prec.tail = next;
      _prec = next;
      _cellX = t;
      continue ;
      
    } else {
      return prec;
    }
  };
}

function copyNonEmptyTo(xs, ys) {
  var cell = {
    head: xs.head,
    tail: empty
  };
  var newTail = copyAux(xs.tail, cell);
  newTail.tail = ys;
  return cell;
}

function append(x, y) {
  var lenX = x.length;
  if (lenX) {
    var lenY = y.length;
    if (lenY) {
      var h = x.data;
      var cell = copyNonEmptyTo(h, y.data);
      return {
              length: lenX + lenY | 0,
              data: cell
            };
    } else {
      return x;
    }
  } else {
    return y;
  }
}

function init(n, f) {
  if (n < 0) {
    throw new Error("Invalid_argument");
  } else if (n) {
    var headX = {
      head: f(0),
      tail: empty
    };
    var cur = headX;
    var i = 1;
    while(i < n) {
      var v = {
        head: f(i),
        tail: empty
      };
      cur.tail = v;
      cur = v;
      i = i + 1 | 0;
    };
    return {
            length: n,
            data: headX
          };
  } else {
    return {
            length: 0,
            data: empty
          };
  }
}

function fillAux(arr, _i, _cell_opt) {
  while(true) {
    var cell_opt = _cell_opt;
    var i = _i;
    if (cell_opt !== null) {
      arr[i] = cell_opt.head;
      _cell_opt = cell_opt.tail;
      _i = i + 1 | 0;
      continue ;
      
    } else {
      return /* () */0;
    }
  };
}

function toArray(x) {
  var len = x.length;
  var arr = new Array(len);
  fillAux(arr, 0, x.data);
  return arr;
}

exports.toOpt          = toOpt;
exports.$$return       = $$return;
exports.empty          = empty;
exports.headOpt        = headOpt;
exports.tailOpt        = tailOpt;
exports.lengthCellAux  = lengthCellAux;
exports.checkInvariant = checkInvariant;
exports.nextAuxAssert  = nextAuxAssert;
exports.nthOpt         = nthOpt;
exports.nthAssert      = nthAssert;
exports.copyAux        = copyAux;
exports.copyNonEmptyTo = copyNonEmptyTo;
exports.append         = append;
exports.init           = init;
exports.fillAux        = fillAux;
exports.toArray        = toArray;
/* empty Not a pure module */
