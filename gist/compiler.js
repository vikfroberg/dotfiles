// Result

const Result = {}

Result.Ok = x => ({
  _type: "Result.Ok",
  toString: () => `Result.Ok (${x.toString()})`,
  andThen: fn => fn(x),
})

Result.Error = x => ({
  _type: "Result.Error",
  toString: () => `Result.Error (${x.toString()})`,
  andThen: fn => Result.Error(x),
})

// Parser Combinator

const Parser = (result, context) => ({
  _type: "Parser",
  toString: () => `Parser (${result.toString()}, ${context.toString()})`,
})

const int = context =>
  context[0].match(/\d/)
    ? Parser(Result.Ok(context[0]), context.slice(1))
    : Parser(Result.Error(), context)


const literal = context =>
  context[0].match(/[a-z]/)
    ? Parser(Result.Ok(context[0]), context.slice(1))
    : Parser(Result.Error(), context)

const space = context => {
  return context[0] === " "
    ? Parser(Result.Ok(context[0]), context.slice(1))
    : Parser(Result.Error(), context)
}

const many = fn => input => {
  let nextInput
  let currentInput = input
  while (nextInput = fn(currentInput)) {
    currentInput = nextInput
  }
  return currentInput
}

const and = (f1, f2) => context => {
  return ""
  // return f1(context).andThen(x => f2
}

const seq = fs => input => fs.reduce((acc, fn) => acc ? fn(acc) : acc, input)

// Compiler

const parse = and(literal, literal) //seq([many(literal), space, int, space, int])

console.log(
  "program",
  parse("add 1 1").toString()
)

