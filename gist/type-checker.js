const Type = {}

Type.Named = (name) => ({
  nodeType: "Named",
  name: name,
})

Type.Var = (name) => ({
  nodeType: "Var",
  name: name,
})

Type.Function = (...types) => {
  return types.reduceRight((to, from) => ({
    nodeType: "Function",
    from: from,
    to: to
  }));
}

const Expression = {}

Expression.Function = (param, body) => ({
  nodeType: "Function",
  param: param,
  body: body,
})

Expression.Call = (func, arg) => ({
  nodeType: "Call",
  func: func,
  arg: arg,
})

Expression.Var = (name) => ({
  nodeType: "Var",
  name: name,
})

Expression.Int = (value) => ({
  nodeType: "Int",
  value: value,
})

function infer(env, e) {
  switch (e.nodeType) {
    case "Int":
      return Type.Named("Int");
    case "Var":
      if (env[e.name]) {
        return env[e.name];
      } else {
        throw `Unbound var ${env.name}`;
      }
    case "Call":
      throw `Unimplemented ${e.nodeType}`;
    default:
      throw `Unimplemented ${e.nodeType}`;
  }
}

console.log(
  infer(
    {
      "True": Type.Named("Bool"),
      "False": Type.Named("Bool"),
      "Int.inc": Type.Function(
        Type.Named("Int"),
        Type.Named("Int"),
      ),
    },
    Expression.Call("Int.inc", Expression.Int(1)),
  )
)
