const log = (k, x) => {
  console.log(k, JSON.stringify(x, null, 2))
  return x
}
console.log("----------------------------------------------------")
const toList = x => Object.keys(x).map(k => [k, x[k]])

let tVarId = 0
const t = {
  named: x => ["TNamed", x],
  func: (x, y) => ["TFunc", x, y],
  var: () => ["TVar", "T" + (++tVarId)],
}

const n = x => ["Num", x]
const v = x => ["Var", x]
const f = (x, y) => ["Func", x, y]
const c = (x, y) => ["Call", x, y]

function infer (env, expr) {
  const [id, ...rest] = expr
  switch (id) {
    case "Num": {
      return [t.named("Num"), {}]
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
      const paramTypeVar = t.var()
      const funcEnv = { ...env, [param]: paramTypeVar }
      const [bodyType, bodySubst] = infer(funcEnv, body)
      const inferedType = t.func(
        applySubstToType(bodySubst, paramTypeVar),
        bodyType
      )
      return [inferedType, bodySubst]
    }
    case "Call": {
      const [func, arg] = rest
      const [funcType, funcSubst] = infer(env, func)
      const [argType, argSubst] = infer(
        applySubstToEnv(funcSubst, env),
        arg
      )
      // const callSubst = unionSubst(funcSubst, argSubst)
      // const toTypeVar = t.var()
      // const unifiedSubst = unify(
      //   t.func(argType, toTypeVar),
      //   funcType
      // )
      // const [id, from, to]  = applySubstToType(unifiedSubst, funcType)
      // const s5 = unionSubst(callSubst, unifiedSubst)
      // const s6 = unify(applySubstToType(s5, from), argType)
      // const resultSubst = unionSubst(s5, s6)
      // const res = [applySubstToType(resultSubst, to), resultSubst]

      log("Call", {
        func,
        arg,
        funcType,
        funcSubst,
        argType,
        argSubst,
        // callSubst,
        // toTypeVar,
        // unifiedSubst,
        // id, from, to,
        // s5,s6,resultSubst
      })

      return [ funcType[2], funcSubst ]
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
//   return toList(ys).reduce(
//     (acc, ([k, y]) => ({ ...acc, [k] = applySubstToType(xs, y) })),
//     start
//   )
// }

function applySubstToEnv(subst, env) {
  return toList(env).reduce(
    (acc, [key, type]) => ({ ...acc, [key]: applySubstToType(subst, type) }),
    {}
  )
}

function unionSubst(s1, s2) {
  return toList(s2).reduce(
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

const inc = f("x", c(c(v("add"), v("x")), n(1)))
const dec = f("x", c(c(v("add"), v("x")), n(-1)))

log("infered",
  infer(
    { add: t.func(t.named("Num"), t.func(t.named("Num"), t.named("Num")))
    },
    log("ast", f("x", c(dec, c(inc, v("x")))))
  )
)
