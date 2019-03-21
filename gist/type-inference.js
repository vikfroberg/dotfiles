const log = (...rest) => {
  console.log(rest)
}

// toKeyedList : Dict k a -> List ( k, a )
const toKeyedList = x => Object.keys(x).map(k => [k, x[k]])

// toKeyedList : List ( k, a ) -> Dict k a
const fromKeyedList = xs => xs.reduce((acc, [k, v]) => ({ ...acc, [k]: v }), {})

Object.prototype.map = function(f) {
  return fromKeyedList(toKeyedList(this).map(([k, v]) => [k, f(v)]))
}

Object.prototype.toString = function(sep = ", ", ksep = ": ") {
  const keyedList = toKeyedList(this)
  if (keyedList.length) {
    return ["{", keyedList.map(x => x.join(ksep)).join(sep), "}"].join(" ")
  } else {
    return "{}"
  }
};

(function v2() {
  const TVar = (id, kind) => ["Tvar", id, kind]
  const TCon = (id, types) => ["TCon", id, types]
  const TAp = (t1, t2) => ["TAp", t1, t2]
  const TGen = i => ["TGen", i]

  const tInt = TCon("Int", 0)
  const tBool = TCon("Bool", 0)
  const tArrow = TCon("(->)", 2)
  const tList = TCon("List", 1)
  const tMaybe = TCon("Maybe", 1)

  const fn = (...types) => {
    return types.reduceRight((to, from) => TAp(TAp(tArrow, from), to))
  }

  const tAdd = fn(tInt, tInt, tInt)
  const tMaybeMaybeInt = TAp(tMaybe, TAp(tMaybe, tInt))
  const tMaybeMaybeMaybeInt = TAp(tMaybe, tMaybeMaybeInt)

  function typeToString([type, ...rest], level = 0) {
    if (type === "TCon") {
      const [id, kind] = rest
      const match = id.match(/\((.+)\)$/)
      if (match) {
        return x => y => `${x} ${match[1]} ${y}`
      } else {
        if (kind > 0) {
          return x => level > 0 ? `(${[id, x].join(" ")})` : [id, x].join(" ")
        } else {
          return id
        }
      }
    } else if (type === "TAp") {
      const [t1, t2] = rest
      return typeToString(t1, level)(typeToString(t2, level + 1))
    } else {
      throw "Unknown Type " + id
    }
  }

  console.log(typeToString(tAdd))
  console.log(typeToString(tMaybeMaybeInt))
  console.log(typeToString(tMaybeMaybeMaybeInt))
})();

// tNum : Type
const tNum = ["TNamed", "Num", []]

// tBool : Type
const tBool = ["TNamed", "Bool", []]

// tVar : () -> Type
let tVarId = 0
const tVar = name => ["TVar", name ? name : "T" + (++tVarId)]

// tMaybe : Type
const tMaybe = (...types) => ["TNamed", "Maybe", types.map(x => typeof x === "string" ? tVar(x) : x)]

// tArrow : Type
const tArrow = (t1, t2) => ["TNamed", "(->)", [t1, t2].map(x => typeof x === "string" ? tVar(x) : x)]

// tFunc : List (String|Type) -> Type
const tFunc = (...types) => {
  return types.reduceRight((to, from) => tArrow(from, to))
}

// tForall : List String -> Type -> Forall
const tForall = (quantifiers, type) => ["Forall", quantifiers, type]

// n : Num -> Expr
const n = x => ["Num", x]

// v : String -> Expr
const v = x => ["Var", x]

// fn : List String|Number|Expr -> Expr
const fn = (...args) => {
  const [body, arg, ...restArgs] = args.reverse()
  return restArgs.reduce((acc, x) => f(x, acc), f(arg, body))
}

// f : String -> String|Number|Expr -> Expr
const f = (param, body) => {
  return ["Lamda", param, typeof body === "string" ? v(body) : typeof body === "number" ? n(body) : body ]
}

// c : List (String|Number|Expr) -> Expr
const c = (f, ...rest) => {
  return rest
    .reduce((func, arg) => ([
      "Call",
      func,
      typeof arg === "string" ? v(arg) : typeof arg === "number" ? n(arg) : arg,
    ]), typeof f === "string" ? v(f) : f)
}

// Expr
// : Num Number
// | Lamda Expr Expr
// | Var String
// | Call Expr Expr

// Type
// : TNamed String [Type]
// | TFunc Type Type
// | TVar String

// Forall : { quantifiers : List String, type : Type }

// Env : Dict String (Type|Forall)

// Subst : Dict String Type

// infer : Env -> Expr -> Type | Error
function infer (env, expr, level = 0) {
  const [id, ...rest] = expr
  console.group(id, exprToString(expr))
  switch (id) {
    case "Num": {
      const res = [tNum, {}]
      log(typeToString(res[0]), res[1].map(typeToString).toString())
      console.groupEnd()
      return res
    }
    case "Var": {
      const [name] = rest
      const envType = env[name]
      if (envType) {
        const [tid, ...rest] = envType
        if (tid === "Forall") {
          const res = [instantiate(envType), {}]
          log(typeToString(res[0]), res[1].map(typeToString).toString())
          console.groupEnd()
          return res
        } else {
          const res = [envType, {}]
          log(typeToString(res[0]), res[1].map(typeToString).toString())
          console.groupEnd()
          return res
        }
      } else {
        console.groupEnd()
        throw `Unbound var ${name}`
      }
    }
    case "Ap": {
      const [func, arg] = rest
      const [funcType, funcSubst] = infer(env, func)
      const [argType, argSubst] = infer(env, arg)
      const tmpFunc = tArrow(argType, tVar())
      const s3 = unify(tmpFunc, funcType)

      const funcType1 = applySubstToType(s3, funcType)
      const s4 = composeSubst(funcSubst, argSubst)
      const s5 = composeSubst(s4, s3)
      const s6 = unify(applySubstToType(s5, funcType1[2][0]), argType)
      const s7 = composeSubst(s5, s6)
      const res = [applySubstToType(s7, funcType1[2][1]), s7]

      log(typeToString(res[0]), res[1].map(typeToString).toString(), { before: typeToString(funcType), _after: typeToString(funcType1) })
      console.groupEnd()
      return res
    }
    default: {
      throw "Unknown expression " + exprToString(expr)
    }
  }
}

// instantiate : Forall -> Type
function instantiate([id, quantifiers, type]) {
  const subst = quantifiers.reduce(
    (acc, name) => ({ ...acc, [name]: tVar() }),
    {}
  )
  return applySubstToType(subst, type);
}

const zip = (as, bs) => as.map((a, i) => [a, bs[i]])

// unify : Type -> Type -> Subst
function unify(t1, t2) {
  const [id1, ...rest1] = t1
  const [id2, ...rest2] = t2

  if (id1 === "TNamed" && id2 === "TNamed") {
    const [name1, types1] = rest1
    const [name2, types2] = rest2
    if (name1 === name2) {
      return zip(types1, types2)
        .reduce((subst, [t1, t2]) =>
          composeSubst(subst, unify(applySubstToType(subst, t1), applySubstToType(subst, t2))),
          {}
        )
    } else {
      throw `Type mismatch:\n    Expected ${typeToString(t1)}\n    Found ${typeToString(t2)}`
    }
  } else if (id1 === "TVar") {
    const [name] = rest1
    return varBind(name, t2)
  } else if (id2 === "TVar") {
    const [name] = rest2
    return varBind(name, t1)
  } else {
    throw `Type mismatch:\n    Expected ${typeToString(t1)}\n    Found ${typeToString(t2)}`
  }
}

// varBind : String -> Type -> Subst
function varBind(name, type) {
  const [id, ...rest] = type
  if (id === "Var" ) {
    const [tname] = rest
    if (tname === name)  {
      return {}
    }
  } else if (contains(type, name)) {
    throw `Type ${typeToString(t)} contains a reference to itself`
  } else {
    return { [name]: type }
  }
}

// contains : Type -> String -> Bool
function contains(type, name) {
  const [id, ...rest] = type
  switch (id) {
    case "Named":
      return false
    case "Var":
      const [tname] = rest
      return tname === name
    case "Function":
      const [from, to] = rest
      return contains(from, name) || contains(to, name)
  }
}

// applySubstToEnv : Subst -> Env -> Env
function applySubstToEnv(subst, env) {
  const newEnv = env.map(type => applySubstToType(subst, type))
  return newEnv
}

// composeSubst : Subst -> Subst -> Subst
function composeSubst(s1, s2) {
  const s3 = s2.map(type => applySubstToType(s1, type))
  return { ...s1, ...s3 }
}

function applySubstToForall(subst, [id, quantifiers, type]) {
  const substWithoutBound = { ...subst };
  for (const name of quantifiers) {
    delete substWithoutBound[name];
  }
  return [id, quantifiers, applySubstToType(substWithoutBound, type)]
}

// applySubstToType : Subst -> Type -> Type
function applySubstToType(subst, type) {
  const [id, ...rest] = type
  switch (id) {
    case "TNamed": {
      const [name, types] = rest
      if (types.length > 0) {
        return [id, name, types.map(t => applySubstToType(subst, t))]
      } else {
        return type
      }
    }
    case "TVar": {
      const [name] = rest
      const substType = subst[name]
      if (substType) {
        return substType
      } else {
        return type
      }
    }
    case "Forall": {
      return applySubstToForall(subst, type)
    }
    default: {
      throw "Unknown type " + type
    }
  }
}

// typeToString : Type -> String
function typeToString(type, r = false) {
  const [id, ...rest] = type
  switch (id) {
    case "TNamed":
      return [rest[0], ...(rest[1].map(typeToString))].join(" ")
    case "TVar":
      return rest[0]
    case "TFunc":
      const [from, to] = rest
      const fromStr = typeToString(from, true)
      const toStr = typeToString(to, to[0] !== "TFunc")
      const sig = `${fromStr} -> ${toStr}`
      return r ? `(${sig})` : sig
    case "Forall":
      const [quantifiers, ftype] = rest
      return typeToString(ftype)
    default:
      throw "Unknown type " + id
  }
}

// exprToString : Expr -> String
function exprToString(expr) {
  const [id, ...rest] = expr
  switch (id) {
    case "Num":
    case "Var":
      return rest[0]
    case "Ap": {
      return exprToString(rest[0]) + "(" + exprToString(rest[1]) + ")"
    }
    default:
      throw "Unsupported expr " + expr
  }
}

// evaluateExpr a : Expr -> Dict String a -> a
function evaluateExpr(expr, env) {
  const [id, ...rest] = expr
  switch (id) {
    case "Num":
      return rest[0]
    case "Var":
      return env[rest[0]]
    case "Lamda":
      return x => evaluateExpr(rest[1], { ...env, [rest[0]]: x })
    case "Call":
      return evaluateExpr(rest[0], env)(evaluateExpr(rest[1], env))
  }
}

const maybe = {
  "Maybe.Just": tForall(["a"], tarrow("a", tMaybe("a"))),
  "Maybe.Just.fold": tForall(["a", "b"], tArrow(tArrow("a", "b"), tArrow(tMaybe("a"), "b"))),
  "Maybe.Nothing": tForall(["a"], tMaybe("a")),
  "Maybe.Nothing.fold": tForall(["a", "b"], tArrow("b", tArrow(tMaybe("a"), "b"))),
  "case": tForall(["a", "b"], tArrow(tList(tArrow("a", "b")), tArrow(tMaybe("a"), "b"))),
}

// const maybeMap = fn("f", "m", c("case", [ ???

// When generating documentation you add examples in real code type
// check them and then generate them as gists in doc

// Represent type constuctors as a map instead of a list, this makes for param functions

const env = {
  fix: tForall(["a"], tArrow(tArrow("a", "a"), "a")),
  id: tForall(["A"], tArrow("A", "A")),
  add: tArrow(tNum, tArrow(tNum, tNum)),
}

const add2 = fn("x", "y", c("add", "y", "x"))
const inc = f("x", c("add", "x", 1))
const dec = f("x", c("add", "x", -1))
const pipe = fn("f", "g", "x", c("g", c("f", "x")))

// const expr = c("eq", 2, c("id", c("add", "random", "random")))
// const expr = c("pipe", c("add", 1), c("add", 1), c("id", 1))
// const expr = c(pipe, c("add", 1), c("add", 1), 1)
// const expr = c("Maybe.map", fn("x", c("add", "x", 1)), c("Just", 1))
// const expr = c("Maybe.map")
const ap = (fn, arg) => ["Ap", fn, arg]
// const expr = ap(v("id"), ap(ap(v("add"), n(1)), n(1)))
const expr = ap(v("fn"), ap(ap(v("add"), n(1)), v("A")))
console.log(expr)

console.group("Infer")

const infered = infer(
  env,
  expr,
)

console.groupEnd()

console.group("Result")

log("expr", exprToString(expr))
log("type", typeToString(infered[0]))
log("result", evaluateExpr(expr, {
  eq: x => y => x === y,
  id: x => x,
  add: x => y => x + y,
  random: 1,
  pipe: f => g => x => g(f(x)),
  Just: x => ["Just", x],
  "Maybe.map": f => ([t,v]) => t === "Just" ? [t,f(v)] : [t,v],
}))
