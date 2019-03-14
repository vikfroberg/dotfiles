function isInt(n){
  return Number(n) === n && n % 1 === 0;
}

function isFloat(n){
  return Number(n) === n && n % 1 !== 0;
}

const infer = context => expr => {
  const [id, ...rest] = expr
  switch (id) {
    case "Num": {
      return "Number"
    }
    case "String": {
      return "String"
    }
    case "Var": {
      return context.kinds[rest[0]] || "?"
    }
    case "Call": {
      return rest.map(infer(context)).join(" ")
    }
    default: {
      throw "Error" + expr
    }
  }
}

const n = x => [ "Num", x ]
const s = x => [ "String", x ]
const v = x => [ "Var", x ]
const c = (...xs) => [ "Call", ...xs ]

console.log(
  infer(
    { kinds: { "Just": "Maybe" },
    },
  )(
    c(v("Just"), n(1))
  )
)
