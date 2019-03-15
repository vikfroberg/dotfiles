const logger = []
const log = (k, x, level = 0, indent = 0) => {
  if (logger[level]) {
    logger[level].unshift([k.padStart(indent * 2, " "), x])
  } else {
    logger[level] = [[k.padStart(indent * 2, " "), x]]
  }
  return x
}
const toKeyedList = x => Object.keys(x).map(k => [k, x[k]])
const toList = x => Object.keys(x).map(k => x[k])

let tVarId = 0
const t = {
  num: ["TNamed", "Num"],
  func: (x, y) => ["TFunc", x, y],
  var: () => ["TVar", "T" + (++tVarId)],
}

const n = x => ["Num", x]
const v = x => ["Var", x]
const f = (x, y) => [
  "Func",
  x,
  typeof y === "string" ? v(y) : typeof y === "number" ? n(y) : y,
]
const c = (f, ...rest) => {
  return rest
    .map(x => typeof x === "string" ? v(x) : typeof x === "number" ? n(x) : x)
    .reverse()
    .reduce((x, y) => ([
      "Call",
      typeof x === "string" ? v(x) : typeof x === "number" ? n(x) : x,
      typeof y === "string" ? v(y) : typeof y === "number" ? n(y) : y,
    ]), f)
}

function infer (env, expr, level = 0, indent = 0) {
  const [id, ...rest] = expr
  switch (id) {
    case "Num": {
      return [t.num, {}]
    }
    case "Var": {
      const [name] = rest
      if (env[name]) {
        return [env[name], {}]
      } else {
        throw `Unbound var ${name}`
      }
    }
    case "Func" : {
      const [param, body] = rest
      const paramType = t.var()
      const funcEnv = { ...env, [param]: paramType }
      const [bodyType, bodySubst] = infer(funcEnv, body, level + 1)
      const inferedType = t.func(
        applySubstToType(bodySubst, paramType),
        bodyType
      )
      const res = [inferedType, bodySubst]
      // log("Func", [param, typeToString(inferedType)], level)
      return res
    }
    case "Call": {
      const [func, arg] = rest
      const [funcType, funcSubst] = infer(env, func, level + 1)
      const [argType, argSubst] = infer(
        applySubstToEnv(funcSubst, env),
        arg,
        level + 1,
        indent + 1
      )
      const toTypeVar = t.var()
      const s3 = unify(
        t.func(argType, toTypeVar),
        funcType
      )
      const [_, from, to] = funcType1 = applySubstToType(s3, funcType)
      const s4 = unionSubst(funcSubst, argSubst)
      const s5 = unionSubst(s4, s3)
      const s6 = unify(applySubstToType(s5, from), argType)
      const s7 = unionSubst(s5, s6)
      const res = [applySubstToType(s5, to), s5]

      // log("Call", [arg[1], typeToString(["TFunc", from, res[0]])], level)
      // log("Call", {
      //   func,
      //   arg,
      //   funcType,
      //   funcSubst,
      //   argType,
      //   argSubst,
      //   toTypeVar,
      //   s3,
      //   from,
      //   to,
      //   s4,
      //   s5,
      //   s6,
      //   s7
      // }, indent)

      return res
    }
    default: {
      throw "Error" + expr
    }
  }
}

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

// function unionWith(fn, xs, ys, start) {
//   return toKeyedList(ys).reduce(
//     (acc, ([k, y]) => ({ ...acc, [k] = applySubstToType(xs, y) })),
//     start
//   )
// }

function applySubstToEnv(subst, env) {
  return toKeyedList(env).reduce(
    (acc, [key, type]) => ({ ...acc, [key]: applySubstToType(subst, type) }),
    {}
  )
}

function unionSubst(s1, s2) {
  return toKeyedList(s2).reduce(
    (acc, [key, type]) => ({ ...acc, [key]: applySubstToType(s1, type) }),
    s1
  )
}

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
      return t.func(
        applySubstToType(subst, from),
        applySubstToType(subst, to),
      )
  }
}

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

const env = {
  add: t.func(t.num, t.func(t.num, t.num)),
  random: t.num
}

const pipe = f("f", f("g", f("x", c("g", c("f", "x")))))
const id = f("x", "x")

const add2 = f("x", f("y", c("add", "y", "x")))
const inc = f("x", c(add2, "x", 1))
const dec = f("x", c(add2, "x", -1))
const same = c(pipe, inc, dec)

const expr = c(add2, 1, 2)
log("expr", exprToString(expr))

indent = 0
const infered = infer(
  env,
  expr,
  1
)


indent = 0
log("type", typeToString(infered[0]))

logger.flat().forEach(x => console.log(x))
