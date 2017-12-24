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

function nthAux(_x, _n) {
  while(true) {
    var n = _n;
    var x = _x;
    if (x) {
      if (n) {
        _n = n - 1 | 0;
        _x = x[1];
        continue ;
        
      } else {
        return /* Some */[x[0]];
      }
    } else {
      return /* None */0;
    }
  };
}

function nthAuxAssert(_x, _n) {
  while(true) {
    var n = _n;
    var x = _x;
    if (x) {
      if (n) {
        _n = n - 1 | 0;
        _x = x[1];
        continue ;
        
      } else {
        return x[0];
      }
    } else {
      throw new Error("nthAssert");
    }
  };
}

function nthOpt(x, n) {
  if (n < 0) {
    return /* None */0;
  } else {
    return nthAux(x, n);
  }
}

function nthAssert(x, n) {
  if (n < 0) {
    throw new Error("nthAssert");
  } else {
    return nthAuxAssert(x, n);
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

function copyAux(_cellX, _prec) {
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

function append(xs, ys) {
  if (xs) {
    var cell = /* :: */[
      xs[0],
      /* [] */0
    ];
    copyAux(xs[1], cell)[1] = ys;
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

function lengthAux(_x, _acc) {
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

function length(xs) {
  return lengthAux(xs, 0);
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
  var len = lengthAux(x, 0);
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
      _prec = copyAux(xs[0], prec);
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
        flattenAux(copyAux(match[1], cell), xs[1]);
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

function mapRevAux(f, _accu, _xs) {
  while(true) {
    var xs = _xs;
    var accu = _accu;
    if (xs) {
      _xs = xs[1];
      _accu = /* :: */[
        f(xs[0]),
        accu
      ];
      continue ;
      
    } else {
      return accu;
    }
  };
}

function mapRev(f, l) {
  return mapRevAux(f, /* [] */0, l);
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

function mapRevAux2(f, _accu, _l1, _l2) {
  while(true) {
    var l2 = _l2;
    var l1 = _l1;
    var accu = _accu;
    if (l1) {
      if (l2) {
        _l2 = l2[1];
        _l1 = l1[1];
        _accu = /* :: */[
          f(l1[0], l2[0]),
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

function mapRev2(f, l1, l2) {
  return mapRevAux2(f, /* [] */0, l1, l2);
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

function split(param) {
  if (param) {
    var match = param[0];
    var match$1 = split(param[1]);
    return /* tuple */[
            /* :: */[
              match[0],
              match$1[0]
            ],
            /* :: */[
              match[1],
              match$1[1]
            ]
          ];
  } else {
    return /* tuple */[
            /* [] */0,
            /* [] */0
          ];
  }
}

function combine(l1, l2) {
  if (l1) {
    if (l2) {
      return /* :: */[
              /* tuple */[
                l1[0],
                l2[0]
              ],
              combine(l1[1], l2[1])
            ];
    } else {
      throw new Error("List.combine");
    }
  } else if (l2) {
    throw new Error("List.combine");
  } else {
    return /* [] */0;
  }
}

function merge(cmp, l1, l2) {
  if (l1) {
    if (l2) {
      var h2 = l2[0];
      var h1 = l1[0];
      if (cmp(h1, h2) <= 0) {
        return /* :: */[
                h1,
                merge(cmp, l1[1], l2)
              ];
      } else {
        return /* :: */[
                h2,
                merge(cmp, l1, l2[1])
              ];
      }
    } else {
      return l1;
    }
  } else {
    return l2;
  }
}

function chop(_k, _l) {
  while(true) {
    var l = _l;
    var k = _k;
    if (k) {
      if (l) {
        _l = l[1];
        _k = k - 1 | 0;
        continue ;
        
      } else {
        return /* assert false */0;
      }
    } else {
      return l;
    }
  };
}

function stable_sort(cmp, l) {
  var sort = function (n, l) {
    var exit = 0;
    if (n !== 2) {
      if (n !== 3) {
        exit = 1;
      } else if (l) {
        var match = l[1];
        if (match) {
          var match$1 = match[1];
          if (match$1) {
            var x3 = match$1[0];
            var x2 = match[0];
            var x1 = l[0];
            if (cmp(x1, x2) <= 0) {
              if (cmp(x2, x3) <= 0) {
                return /* :: */[
                        x1,
                        /* :: */[
                          x2,
                          /* :: */[
                            x3,
                            /* [] */0
                          ]
                        ]
                      ];
              } else if (cmp(x1, x3) <= 0) {
                return /* :: */[
                        x1,
                        /* :: */[
                          x3,
                          /* :: */[
                            x2,
                            /* [] */0
                          ]
                        ]
                      ];
              } else {
                return /* :: */[
                        x3,
                        /* :: */[
                          x1,
                          /* :: */[
                            x2,
                            /* [] */0
                          ]
                        ]
                      ];
              }
            } else if (cmp(x1, x3) <= 0) {
              return /* :: */[
                      x2,
                      /* :: */[
                        x1,
                        /* :: */[
                          x3,
                          /* [] */0
                        ]
                      ]
                    ];
            } else if (cmp(x2, x3) <= 0) {
              return /* :: */[
                      x2,
                      /* :: */[
                        x3,
                        /* :: */[
                          x1,
                          /* [] */0
                        ]
                      ]
                    ];
            } else {
              return /* :: */[
                      x3,
                      /* :: */[
                        x2,
                        /* :: */[
                          x1,
                          /* [] */0
                        ]
                      ]
                    ];
            }
          } else {
            exit = 1;
          }
        } else {
          exit = 1;
        }
      } else {
        exit = 1;
      }
    } else if (l) {
      var match$2 = l[1];
      if (match$2) {
        var x2$1 = match$2[0];
        var x1$1 = l[0];
        if (cmp(x1$1, x2$1) <= 0) {
          return /* :: */[
                  x1$1,
                  /* :: */[
                    x2$1,
                    /* [] */0
                  ]
                ];
        } else {
          return /* :: */[
                  x2$1,
                  /* :: */[
                    x1$1,
                    /* [] */0
                  ]
                ];
        }
      } else {
        exit = 1;
      }
    } else {
      exit = 1;
    }
    if (exit === 1) {
      var n1 = (n >> 1);
      var n2 = n - n1 | 0;
      var l2 = chop(n1, l);
      var s1 = rev_sort(n1, l);
      var s2 = rev_sort(n2, l2);
      var _l1 = s1;
      var _l2 = s2;
      var _accu = /* [] */0;
      while(true) {
        var accu = _accu;
        var l2$1 = _l2;
        var l1 = _l1;
        if (l1) {
          if (l2$1) {
            var h2 = l2$1[0];
            var h1 = l1[0];
            if (cmp(h1, h2) > 0) {
              _accu = /* :: */[
                h1,
                accu
              ];
              _l1 = l1[1];
              continue ;
              
            } else {
              _accu = /* :: */[
                h2,
                accu
              ];
              _l2 = l2$1[1];
              continue ;
              
            }
          } else {
            return revAppend(l1, accu);
          }
        } else {
          return revAppend(l2$1, accu);
        }
      };
    }
    
  };
  var rev_sort = function (n, l) {
    var exit = 0;
    if (n !== 2) {
      if (n !== 3) {
        exit = 1;
      } else if (l) {
        var match = l[1];
        if (match) {
          var match$1 = match[1];
          if (match$1) {
            var x3 = match$1[0];
            var x2 = match[0];
            var x1 = l[0];
            if (cmp(x1, x2) > 0) {
              if (cmp(x2, x3) > 0) {
                return /* :: */[
                        x1,
                        /* :: */[
                          x2,
                          /* :: */[
                            x3,
                            /* [] */0
                          ]
                        ]
                      ];
              } else if (cmp(x1, x3) > 0) {
                return /* :: */[
                        x1,
                        /* :: */[
                          x3,
                          /* :: */[
                            x2,
                            /* [] */0
                          ]
                        ]
                      ];
              } else {
                return /* :: */[
                        x3,
                        /* :: */[
                          x1,
                          /* :: */[
                            x2,
                            /* [] */0
                          ]
                        ]
                      ];
              }
            } else if (cmp(x1, x3) > 0) {
              return /* :: */[
                      x2,
                      /* :: */[
                        x1,
                        /* :: */[
                          x3,
                          /* [] */0
                        ]
                      ]
                    ];
            } else if (cmp(x2, x3) > 0) {
              return /* :: */[
                      x2,
                      /* :: */[
                        x3,
                        /* :: */[
                          x1,
                          /* [] */0
                        ]
                      ]
                    ];
            } else {
              return /* :: */[
                      x3,
                      /* :: */[
                        x2,
                        /* :: */[
                          x1,
                          /* [] */0
                        ]
                      ]
                    ];
            }
          } else {
            exit = 1;
          }
        } else {
          exit = 1;
        }
      } else {
        exit = 1;
      }
    } else if (l) {
      var match$2 = l[1];
      if (match$2) {
        var x2$1 = match$2[0];
        var x1$1 = l[0];
        if (cmp(x1$1, x2$1) > 0) {
          return /* :: */[
                  x1$1,
                  /* :: */[
                    x2$1,
                    /* [] */0
                  ]
                ];
        } else {
          return /* :: */[
                  x2$1,
                  /* :: */[
                    x1$1,
                    /* [] */0
                  ]
                ];
        }
      } else {
        exit = 1;
      }
    } else {
      exit = 1;
    }
    if (exit === 1) {
      var n1 = (n >> 1);
      var n2 = n - n1 | 0;
      var l2 = chop(n1, l);
      var s1 = sort(n1, l);
      var s2 = sort(n2, l2);
      var _l1 = s1;
      var _l2 = s2;
      var _accu = /* [] */0;
      while(true) {
        var accu = _accu;
        var l2$1 = _l2;
        var l1 = _l1;
        if (l1) {
          if (l2$1) {
            var h2 = l2$1[0];
            var h1 = l1[0];
            if (cmp(h1, h2) <= 0) {
              _accu = /* :: */[
                h1,
                accu
              ];
              _l1 = l1[1];
              continue ;
              
            } else {
              _accu = /* :: */[
                h2,
                accu
              ];
              _l2 = l2$1[1];
              continue ;
              
            }
          } else {
            return revAppend(l1, accu);
          }
        } else {
          return revAppend(l2$1, accu);
        }
      };
    }
    
  };
  var len = lengthAux(l, 0);
  if (len < 2) {
    return l;
  } else {
    return sort(len, l);
  }
}

function sort_uniq(cmp, l) {
  var sort = function (n, l) {
    var exit = 0;
    if (n !== 2) {
      if (n !== 3) {
        exit = 1;
      } else if (l) {
        var match = l[1];
        if (match) {
          var match$1 = match[1];
          if (match$1) {
            var x3 = match$1[0];
            var x2 = match[0];
            var x1 = l[0];
            var c = cmp(x1, x2);
            if (c) {
              if (c < 0) {
                var c$1 = cmp(x2, x3);
                if (c$1) {
                  if (c$1 < 0) {
                    return /* :: */[
                            x1,
                            /* :: */[
                              x2,
                              /* :: */[
                                x3,
                                /* [] */0
                              ]
                            ]
                          ];
                  } else {
                    var c$2 = cmp(x1, x3);
                    if (c$2) {
                      if (c$2 < 0) {
                        return /* :: */[
                                x1,
                                /* :: */[
                                  x3,
                                  /* :: */[
                                    x2,
                                    /* [] */0
                                  ]
                                ]
                              ];
                      } else {
                        return /* :: */[
                                x3,
                                /* :: */[
                                  x1,
                                  /* :: */[
                                    x2,
                                    /* [] */0
                                  ]
                                ]
                              ];
                      }
                    } else {
                      return /* :: */[
                              x1,
                              /* :: */[
                                x2,
                                /* [] */0
                              ]
                            ];
                    }
                  }
                } else {
                  return /* :: */[
                          x1,
                          /* :: */[
                            x2,
                            /* [] */0
                          ]
                        ];
                }
              } else {
                var c$3 = cmp(x1, x3);
                if (c$3) {
                  if (c$3 < 0) {
                    return /* :: */[
                            x2,
                            /* :: */[
                              x1,
                              /* :: */[
                                x3,
                                /* [] */0
                              ]
                            ]
                          ];
                  } else {
                    var c$4 = cmp(x2, x3);
                    if (c$4) {
                      if (c$4 < 0) {
                        return /* :: */[
                                x2,
                                /* :: */[
                                  x3,
                                  /* :: */[
                                    x1,
                                    /* [] */0
                                  ]
                                ]
                              ];
                      } else {
                        return /* :: */[
                                x3,
                                /* :: */[
                                  x2,
                                  /* :: */[
                                    x1,
                                    /* [] */0
                                  ]
                                ]
                              ];
                      }
                    } else {
                      return /* :: */[
                              x2,
                              /* :: */[
                                x1,
                                /* [] */0
                              ]
                            ];
                    }
                  }
                } else {
                  return /* :: */[
                          x2,
                          /* :: */[
                            x1,
                            /* [] */0
                          ]
                        ];
                }
              }
            } else {
              var c$5 = cmp(x2, x3);
              if (c$5) {
                if (c$5 < 0) {
                  return /* :: */[
                          x2,
                          /* :: */[
                            x3,
                            /* [] */0
                          ]
                        ];
                } else {
                  return /* :: */[
                          x3,
                          /* :: */[
                            x2,
                            /* [] */0
                          ]
                        ];
                }
              } else {
                return /* :: */[
                        x2,
                        /* [] */0
                      ];
              }
            }
          } else {
            exit = 1;
          }
        } else {
          exit = 1;
        }
      } else {
        exit = 1;
      }
    } else if (l) {
      var match$2 = l[1];
      if (match$2) {
        var x2$1 = match$2[0];
        var x1$1 = l[0];
        var c$6 = cmp(x1$1, x2$1);
        if (c$6) {
          if (c$6 < 0) {
            return /* :: */[
                    x1$1,
                    /* :: */[
                      x2$1,
                      /* [] */0
                    ]
                  ];
          } else {
            return /* :: */[
                    x2$1,
                    /* :: */[
                      x1$1,
                      /* [] */0
                    ]
                  ];
          }
        } else {
          return /* :: */[
                  x1$1,
                  /* [] */0
                ];
        }
      } else {
        exit = 1;
      }
    } else {
      exit = 1;
    }
    if (exit === 1) {
      var n1 = (n >> 1);
      var n2 = n - n1 | 0;
      var l2 = chop(n1, l);
      var s1 = rev_sort(n1, l);
      var s2 = rev_sort(n2, l2);
      var _l1 = s1;
      var _l2 = s2;
      var _accu = /* [] */0;
      while(true) {
        var accu = _accu;
        var l2$1 = _l2;
        var l1 = _l1;
        if (l1) {
          if (l2$1) {
            var t2 = l2$1[1];
            var h2 = l2$1[0];
            var t1 = l1[1];
            var h1 = l1[0];
            var c$7 = cmp(h1, h2);
            if (c$7) {
              if (c$7 > 0) {
                _accu = /* :: */[
                  h1,
                  accu
                ];
                _l1 = t1;
                continue ;
                
              } else {
                _accu = /* :: */[
                  h2,
                  accu
                ];
                _l2 = t2;
                continue ;
                
              }
            } else {
              _accu = /* :: */[
                h1,
                accu
              ];
              _l2 = t2;
              _l1 = t1;
              continue ;
              
            }
          } else {
            return revAppend(l1, accu);
          }
        } else {
          return revAppend(l2$1, accu);
        }
      };
    }
    
  };
  var rev_sort = function (n, l) {
    var exit = 0;
    if (n !== 2) {
      if (n !== 3) {
        exit = 1;
      } else if (l) {
        var match = l[1];
        if (match) {
          var match$1 = match[1];
          if (match$1) {
            var x3 = match$1[0];
            var x2 = match[0];
            var x1 = l[0];
            var c = cmp(x1, x2);
            if (c) {
              if (c > 0) {
                var c$1 = cmp(x2, x3);
                if (c$1) {
                  if (c$1 > 0) {
                    return /* :: */[
                            x1,
                            /* :: */[
                              x2,
                              /* :: */[
                                x3,
                                /* [] */0
                              ]
                            ]
                          ];
                  } else {
                    var c$2 = cmp(x1, x3);
                    if (c$2) {
                      if (c$2 > 0) {
                        return /* :: */[
                                x1,
                                /* :: */[
                                  x3,
                                  /* :: */[
                                    x2,
                                    /* [] */0
                                  ]
                                ]
                              ];
                      } else {
                        return /* :: */[
                                x3,
                                /* :: */[
                                  x1,
                                  /* :: */[
                                    x2,
                                    /* [] */0
                                  ]
                                ]
                              ];
                      }
                    } else {
                      return /* :: */[
                              x1,
                              /* :: */[
                                x2,
                                /* [] */0
                              ]
                            ];
                    }
                  }
                } else {
                  return /* :: */[
                          x1,
                          /* :: */[
                            x2,
                            /* [] */0
                          ]
                        ];
                }
              } else {
                var c$3 = cmp(x1, x3);
                if (c$3) {
                  if (c$3 > 0) {
                    return /* :: */[
                            x2,
                            /* :: */[
                              x1,
                              /* :: */[
                                x3,
                                /* [] */0
                              ]
                            ]
                          ];
                  } else {
                    var c$4 = cmp(x2, x3);
                    if (c$4) {
                      if (c$4 > 0) {
                        return /* :: */[
                                x2,
                                /* :: */[
                                  x3,
                                  /* :: */[
                                    x1,
                                    /* [] */0
                                  ]
                                ]
                              ];
                      } else {
                        return /* :: */[
                                x3,
                                /* :: */[
                                  x2,
                                  /* :: */[
                                    x1,
                                    /* [] */0
                                  ]
                                ]
                              ];
                      }
                    } else {
                      return /* :: */[
                              x2,
                              /* :: */[
                                x1,
                                /* [] */0
                              ]
                            ];
                    }
                  }
                } else {
                  return /* :: */[
                          x2,
                          /* :: */[
                            x1,
                            /* [] */0
                          ]
                        ];
                }
              }
            } else {
              var c$5 = cmp(x2, x3);
              if (c$5) {
                if (c$5 > 0) {
                  return /* :: */[
                          x2,
                          /* :: */[
                            x3,
                            /* [] */0
                          ]
                        ];
                } else {
                  return /* :: */[
                          x3,
                          /* :: */[
                            x2,
                            /* [] */0
                          ]
                        ];
                }
              } else {
                return /* :: */[
                        x2,
                        /* [] */0
                      ];
              }
            }
          } else {
            exit = 1;
          }
        } else {
          exit = 1;
        }
      } else {
        exit = 1;
      }
    } else if (l) {
      var match$2 = l[1];
      if (match$2) {
        var x2$1 = match$2[0];
        var x1$1 = l[0];
        var c$6 = cmp(x1$1, x2$1);
        if (c$6) {
          if (c$6 > 0) {
            return /* :: */[
                    x1$1,
                    /* :: */[
                      x2$1,
                      /* [] */0
                    ]
                  ];
          } else {
            return /* :: */[
                    x2$1,
                    /* :: */[
                      x1$1,
                      /* [] */0
                    ]
                  ];
          }
        } else {
          return /* :: */[
                  x1$1,
                  /* [] */0
                ];
        }
      } else {
        exit = 1;
      }
    } else {
      exit = 1;
    }
    if (exit === 1) {
      var n1 = (n >> 1);
      var n2 = n - n1 | 0;
      var l2 = chop(n1, l);
      var s1 = sort(n1, l);
      var s2 = sort(n2, l2);
      var _l1 = s1;
      var _l2 = s2;
      var _accu = /* [] */0;
      while(true) {
        var accu = _accu;
        var l2$1 = _l2;
        var l1 = _l1;
        if (l1) {
          if (l2$1) {
            var t2 = l2$1[1];
            var h2 = l2$1[0];
            var t1 = l1[1];
            var h1 = l1[0];
            var c$7 = cmp(h1, h2);
            if (c$7) {
              if (c$7 < 0) {
                _accu = /* :: */[
                  h1,
                  accu
                ];
                _l1 = t1;
                continue ;
                
              } else {
                _accu = /* :: */[
                  h2,
                  accu
                ];
                _l2 = t2;
                continue ;
                
              }
            } else {
              _accu = /* :: */[
                h1,
                accu
              ];
              _l2 = t2;
              _l1 = t1;
              continue ;
              
            }
          } else {
            return revAppend(l1, accu);
          }
        } else {
          return revAppend(l2$1, accu);
        }
      };
    }
    
  };
  var len = lengthAux(l, 0);
  if (len < 2) {
    return l;
  } else {
    return sort(len, l);
  }
}

var sort = stable_sort;

var fast_sort = stable_sort;

exports.headOpt          = headOpt;
exports.tailOpt          = tailOpt;
exports.nthAux           = nthAux;
exports.nthAuxAssert     = nthAuxAssert;
exports.nthOpt           = nthOpt;
exports.nthAssert        = nthAssert;
exports.partitionAux     = partitionAux;
exports.copyAux          = copyAux;
exports.copyAuxWitFilter = copyAuxWitFilter;
exports.copyAuxWithMap   = copyAuxWithMap;
exports.copyAuxWithMap2  = copyAuxWithMap2;
exports.copyAuxWithMapI  = copyAuxWithMapI;
exports.append           = append;
exports.map              = map;
exports.map2             = map2;
exports.mapi             = mapi;
exports.init             = init;
exports.lengthAux        = lengthAux;
exports.length           = length;
exports.fillAux          = fillAux;
exports.toArray          = toArray;
exports.revAppend        = revAppend;
exports.rev              = rev;
exports.flattenAux       = flattenAux;
exports.flatten          = flatten;
exports.mapRevAux        = mapRevAux;
exports.mapRev           = mapRev;
exports.iter             = iter;
exports.iteri            = iteri;
exports.foldLeft         = foldLeft;
exports.foldRight        = foldRight;
exports.mapRevAux2       = mapRevAux2;
exports.mapRev2          = mapRev2;
exports.iter2            = iter2;
exports.foldLeft2        = foldLeft2;
exports.foldRight2       = foldRight2;
exports.forAll           = forAll;
exports.exists           = exists;
exports.forAll2          = forAll2;
exports.exists2          = exists2;
exports.mem              = mem;
exports.memq             = memq;
exports.assocOpt         = assocOpt;
exports.assqOpt          = assqOpt;
exports.memAssoc         = memAssoc;
exports.memAssq          = memAssq;
exports.removeAssoc      = removeAssoc;
exports.removeAssq       = removeAssq;
exports.findOpt          = findOpt;
exports.filter           = filter;
exports.partition        = partition;
exports.split            = split;
exports.combine          = combine;
exports.merge            = merge;
exports.chop             = chop;
exports.stable_sort      = stable_sort;
exports.sort             = sort;
exports.fast_sort        = fast_sort;
exports.sort_uniq        = sort_uniq;
/* No side effect */
