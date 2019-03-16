// log : k -> a -> a
const log = (k, x) => {
  console.log(k, x)
  return x
}

// toKeyedList : Map k a -> List ( k, a )
const toKeyedList = x => Object.keys(x).map(k => [k, x[k]])

// toList : Map k a -> List a
const toList = x => Object.keys(x).map(k => x[k])

// tnum : Type
const tnum = ["TNamed", "Num"]

// tbool : Type
const tbool = ["TNamed", "Bool"]

// tvar : () -> Type
let tVarId = 0
const tvar = name => ["TVar", name ? name : "T" + (++tVarId)]

// tfunc : List (String|Type) -> Type
const tfunc = (from, ...rest) => {
  return rest
    .reduceRight((x, y) => ([
      "TFunc",
      typeof y === "string" ? tvar(y) : y,
      typeof x === "string" ? tvar(x) : x,
    ]), from)
}

// tforall : List String -> Type -> Forall
const tforall = (quantifiers, type) => ["Forall", quantifiers, type]

// n : Num -> Expr
const n = x => ["Num", x]

// v : String -> Expr
const v = x => ["Var", x]

// f : String -> String|Number|Expr -> Expr
const f = (x, y) => [
  "Func",
  x,
  typeof y === "string" ? v(y) : typeof y === "number" ? n(y) : y,
]

// c : List (String|Number|Expr) -> Expr
const c = (f, ...rest) => {
  return rest
    .reduce((x, y) => ([
      "Call",
      typeof x === "string" ? v(x) : typeof x === "number" ? n(x) : x,
      typeof y === "string" ? v(y) : typeof y === "number" ? n(y) : y,
    ]), f)
}

// Expr
// : Num Number
// | Func Expr Expr
// | Var String
// | Call Expr Expr

// Type
// : TNamed String
// | TFunc Type Type
// | TVar String

// Forall : { quantifiers : List String, type : Type }

// Env : Dict String (Type|Forall)

// Subst : Dict String Type

// infer : Env -> Expr -> Type | Error
function infer (env, expr, level = 0) {
  const [id, ...rest] = expr
  console.log("in", { id, env, expr, level })
  switch (id) {
    case "Num": {
      const res = [tnum, {}]
      console.log("out", { id, res, expr, level})
      return res
    }
    case "Var": {
      const [name] = rest
      const envType = env[name]
      if (envType) {
        const [tid, ...rest] = envType
        if (tid === "Forall") {
          const res = [instantiate(envType), {}]
          console.log("out", { id, tid, env, res, expr, level})
          return res
        } else {
          const res = [envType, {}]
          console.log("out", { id, tid, env, res, expr, level})
          return res
        }
      } else {
        throw `Unbound var ${name}`
      }
    }
    case "Func" : {
      const [param, body] = rest
      const paramType = tvar()
      const funcEnv = { ...env, [param]: paramType }
      const [bodyType, bodySubst] = infer(funcEnv, body, level + 1)
      const inferedType = tfunc(
        applySubstToType(bodySubst, paramType),
        bodyType
      )
      const res = [inferedType, bodySubst]
      console.log("out", { id, env, res, expr, level})
      return res
    }
    case "Call": {
      const [func, arg] = rest
      const [funcType, funcSubst] = infer(env, func, level + 1)
      const [argType, argSubst] = infer(applySubstToEnv(funcSubst, env), arg, level + 1)
      const toTypeVar = tvar()
      const s3 = unify(
        tfunc(argType, toTypeVar),
        funcType
      )
      const [_, from, to] = funcType1 = applySubstToType(s3, funcType)
      const s4 = unionSubst(funcSubst, argSubst)
      const s5 = unionSubst(s4, s3)
      console.log({ from, argType })
      const s6 = unify(applySubstToType(s5, from), argType)
      const s7 = unionSubst(s5, s6)
      const res = [applySubstToType(s7, to), s7]
      console.log("out", { id, env, res, expr, level})
      return res
    }
    default: {
      // throw "Error" + expr
    }
  }
}

// instantiate : Forall -> Type
function instantiate([id, quantifiers, type]) {
  const subst = quantifiers.reduce(
    (acc, name) => ({ ...acc, [name]: tvar() }),
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
        applySubstToType(s1, to2),
        applySubstToType(s1, to2)
      )
      return unionSubst(s1, s2)
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
  return toKeyedList(env).reduce(
    (acc, [key, type]) => ({ ...acc, [key]: type[0] === "Forall" ? applySubstToForall(subst, type) : applySubstToType(subst, type) }),
    {}
  )
}

// unionSubst : Subst -> Subst -> Subst
function unionSubst(s1, s2) {
  return toKeyedList(s2).reduce(
    (acc, [key, type]) => ({ ...acc, [key]: applySubstToType(s1, type) }),
    s1
  )
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
      return type
    }
    case "TVar": {
      const [name] = rest
      if (subst[name]) {
        return subst[name]
      } else {
        return type
      }
    }
    case "TFunc":
      const [from, to] = rest
      return tfunc(
        applySubstToType(subst, from),
        applySubstToType(subst, to),
      )
  }
}

// typeToString : Type -> String
function typeToString(type) {
  const [id, ...rest] = type
  switch (id) {
    case "TNamed":
      return rest[0]
    case "TVar":
      return rest[0]
    case "TFunc":
      return rest.map(typeToString).join(" -> ")
  }
  return id
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
  add: log("add", tfunc(tnum, tnum, tnum)),
  random: tnum
  // id: tforall(["A"], tfunc("A", "A")),
  // eq: tforall(["B"], tfunc("B", "B", tbool)),
  // pipe: tforall([], tfunc(tfunc("FA", "FB"), tfunc("GA", "GB"), tfunc("FA", "GB"))),
}

// const pipe = f("f", f("g", f("x", c("g", c("f", "x")))))
// const wrap = f("wrapF", f("wrapX", c("wrapF", "wrapX")))
// const id = f("idX", "idX")
// const add2 = f("x", f("y", c("add", "y", "x")))
// const inc = f("x", c("add", "x", 1))
// const dec = f("x", c("add", "x", -1))
// const same = c(pipe, inc, dec)

const expr = c("add", 1, 1)

const infered = infer(
  env,
  expr,
)

log("expr", exprToString(expr))
log("type", typeToString(infered[0]))
log("result", evaluateExpr(expr, { eq: x => y => x === y, id: x => x, add: x => y => x + y }))
