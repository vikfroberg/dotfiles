const log = (...rest) => {
  console.log(rest)
}

const logLevel = (level, ...rest) => {
  console.log(String(level).padStart(level * 2), ...rest)
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

  const makeFunc = (...types) => {
    return types.reduceRight((to, from) => TAp(TAp(tArrow, from), to))
  }

  const tAdd = makeFunc(tInt, tInt, tInt)

  function typeToString([type, ...rest]) {
    if (type === "TCon") {
      const [id, kind] = rest
      if (kind === 1) {
        return x => `${id} ${x}`
      } else if (kind === 2) {
        const match = id.match(/\((.+)\)$/)
        if (match) {
          return x => y => `${x} ${match[1]} ${y}`
        } else {
          return x => y => `${id} ${x} ${y}`
        }
      } else {
        return id
      }
    } else if (type === "TAp") {
      const [t1, t2] = rest
      return typeToString(t1)(typeToString(t2))
    } else {
      throw "unknown type"
    }
  }

  console.log(typeToString(tAdd))
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

const tArrow = ["TNamed", "(->)", [tVar("a"), tVar("b")]]

// tFunc : List (String|Type) -> Type
const tFunc = (...types) => {
  return types
    .reduceRight((to, from) => ([
      "TFunc",
      typeof from === "string" ? tVar(from) : from,
      typeof to === "string" ? tVar(to) : to,
    ]))
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
  return ["Func", param, typeof body === "string" ? v(body) : typeof body === "number" ? n(body) : body ]
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
// | Func Expr Expr
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
        throw `Unbound var ${name}`
      }
    }
    case "Func" : {
      const [param, body] = rest
      const paramType = tVar()
      // check if in env already
      const funcEnv = { ...env, [param]: paramType }
      const [bodyType, bodySubst] = infer(funcEnv, body, level + 1)
      const inferedType = tFunc(
        applySubstToType(bodySubst, paramType),
        bodyType
      )
      const res = [inferedType, bodySubst]
      log(typeToString(res[0]), res[1].map(typeToString).toString())
      console.groupEnd()
      return res
    }
    case "Call": {
      const [func, arg] = rest
      const [funcType, funcSubst] = infer(env, func, level + 1)

      const argEnv = applySubstToEnv(funcSubst, env)
      const [argType, argSubst] = infer(argEnv, arg, level + 1)

      const toTypeVar = tVar()
      const tmpFunc = tFunc(argType, toTypeVar)
      const s3 = unify(
        tmpFunc,
        funcType
      )
      const [_, from, to] = funcType1 = applySubstToType(s3, funcType)
      // const res = [to, s3 ]

      // TODO: Understand this part
      // pipe(add, (add 1), 1) breaks with this correctly
      const s4 = composeSubst(funcSubst, argSubst)
      const s5 = composeSubst(s4, s3)
      const s6 = unify(applySubstToType(s5, from), argType)
      const s7 = composeSubst(s5, s6)
      const res = [applySubstToType(s7, to), s7]

      log(typeToString(res[0]), res[1].map(typeToString).toString(), { before: typeToString(funcType), _after: typeToString(funcType1) })
      console.groupEnd()
      return res
    }
    default: {
      throw "Unknown expression " + id
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

// unify : Type -> Type -> Subst
function unify(t1, t2) {
  const [id1, ...rest1] = t1
  const [id2, ...rest2] = t2

  if (id1 === "TNamed" && id2 === "TNamed") {
    const [name1] = rest1
    const [name2] = rest2
    if (name1 === name2) {
      return {}
    } else {
      throw `Type mismatch:\n    Expected ${typeToString(t1)}\n    Found ${typeToString(t2)}`
    }
  } else if (id1 === "TVar") {
    const [name] = rest1
    return varBind(name, t2)
  } else if (id2 === "TVar") {
    const [name] = rest2
    return varBind(name, t1)
  } else if (id1 === "TFunc" && id2 === "TFunc") {
    const [from1, to1] = rest1
    const [from2, to2] = rest2
      const s1 = unify(from1, from2)
      const s2 = unify(
        applySubstToType(s1, to1),
        applySubstToType(s1, to2)
      )
      return composeSubst(s1, s2)
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
      const [name, kinds] = rest
      if (kinds.length > 0) {
        return [id, name, kinds.map(t => applySubstToType(subst, t))]
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
    case "TFunc": {
      const [from, to] = rest
      // should this call substitute recursive
      return tFunc(
        applySubstToType(subst, from),
        applySubstToType(subst, to),
      )
    }
    case "Forall": {
      return applySubstToForall(subst, type)
    }
    default: {
      throw "Unknown type " + id
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
    case "Func":
      return "(" + rest[0] + " -> " + exprToString(rest[1]) + ")"
    case "Call":
      return exprToString(rest[0]) + "(" + exprToString(rest[1]) + ")"
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
    case "Func":
      return x => evaluateExpr(rest[1], { ...env, [rest[0]]: x })
    case "Call":
      return evaluateExpr(rest[0], env)(evaluateExpr(rest[1], env))
  }
}

const env = {
  add: tFunc(tNum, tNum, tNum),
  pipe: tForall(["FA", "FB", "GA", "GB"], tFunc(tFunc("FA", "FB"), tFunc("GA", "GB"), tFunc("FA", "GB"))),
  id: tForall(["A"], tFunc("A", "A")),
  // eq: tForall(["B"], tFunc("B", "B", tBool)),
  // random: tNum,
  Just: tForall(["A"], tFunc("A", tMaybe("A"))),
  Nothing: tForall(["A"], tMaybe("A")),
  "Maybe.map": tForall(["A", "B"], tFunc(tFunc("A", "B"), tMaybe("A"), tMaybe("B")))
}

const add2 = fn("x", "y", c("add", "y", "x"))
const inc = f("x", c("add", "x", 1))
const dec = f("x", c("add", "x", -1))
const pipe = fn("f", "g", "x", c("g", c("f", "x")))

// const expr = c("eq", 2, c("id", c("add", "random", "random")))
// const expr = c("pipe", c("add", 1), c("add", 1), c("id", 1))
// const expr = c(pipe, c("add", 1), c("add", 1), 1)
// const expr = c("Maybe.map", fn("x", c("add", "x", 1)), c("Just", 1))
const expr = c("Maybe.map")

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
