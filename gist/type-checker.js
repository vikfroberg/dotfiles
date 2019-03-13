// Helpers

function isArray(a) {
  return Array.isArray(a)
}

function isChar(s) {
  return typeof s === "string" && s.length === 1
}

function isString(s) {
  return typeof s === "string" && s.length > 1
}

function isSymbol(s) {
  return typeof s === "string" && s.startsWith("$")
}

function isInt(n){
  return Number(n) === n && n % 1 === 0;
}

function isFloat(n){
  return Number(n) === n && n % 1 !== 0;
}

function astToString(s) {
  return JSON.stringify(s, null, 2)
}



// Compiler

const run = sexpr => {
  function go(expr) {
    if (isArray(expr)) {
      if (expr[0] === "defun") {
        const [ _, name, args, body ] = expr
        return {
          type: "FUNCTION",
          name,
          args,
          body: go(body),
        }
      } else {
        const [symbol, ...args] = expr
        return args.reduce(
          (func, arg) => ({ type: "CALL", func, arg: go(arg) }),
          { type: "SYMBOL", val: symbol }
        )
      }
    } else if (isSymbol(expr)) {
      return { type: "SYMBOL", val: expr.slice(1) }
    } else if (isString(expr)) {
      return { type: "STRING", val: expr }
    } else if (isChar(expr)) {
      return { type: "CHAR", val: expr }
    } else if (isInt(expr)) {
      return { type: "INT", val: expr }
    } else if (isFloat(expr)) {
      return { type: "FLOAT", val: expr }
    } else {
      throw "Unknown type"
    }
  }

  return sexpr.map(go)
}

const astToJs = sast => {
  function go(ast) {
    switch (ast.type) {
      case "FUNCTION": {
        return `function ${ast.name}(${ast.args.join(",")}){return ${go(ast.body)}}`
      }
      case "CALL": {
        return `${go(ast.func)}(${go(ast.arg)})`
      }
      case "STRING":
      case "CHAR": {
        return `"${ast.val}"`
      }
      case "SYMBOL":
      case "INT":
      case "FLOAT": {
        return ast.val.toString()
      }
      default: {
        throw ("Unknown type " + ast.type)
      }
    }
  }

  const env = [
    `function add(x) { return function add_(y) { return x + y } }`,
    `function sub(x) { return function sub_(y) { return x - y } }`,
    `function isArray(a) { return Array.isArray(a) }`,
    `function isChar(s) { return typeof s === "string" && s.length === 1 }`,
    `function isString(s) { return typeof s === "string" && s.length > 1 }`,
    `function isInt(n){ return Number(n) === n && n % 1 === 0; }`,
    `function isFloat(n){ return Number(n) === n && n % 1 !== 0; }`,
  ]
  const gen = sast.map(go).join("\n")
  return [env.join("\n"), "", gen].join("\n")
}

const app = run([
  [ "defun", "add2", [ "x", "y" ], [ "add", "$x", "$y" ] ],
  [ "defun", "increment", [ "x" ], [ "add", "$x", 1 ] ],
  [ "add2", 1, 1 ],
  [ "increment", 1 ]
])

console.log(astToString(app))

console.log(astToJs(app))

// console.log(eval(astToJs(app)))
