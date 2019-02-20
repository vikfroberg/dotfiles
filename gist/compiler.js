// Array

const flatten = xs => xs.reduce((acc, xs) => acc.concat(xs), []);

// Result

const Result = {};

Result.Ok = result => ({
  _type: "Result.Ok",
  _result: result,
  cata: case_ => case_.Ok(result),
  map: fn => Result.Ok(fn(result)),
  mapError: fn => Result.Ok(result),
});

Result.Error = error => ({
  _type: "Result.Error",
  _error: error,
  cata: case_ => case_.Error(error),
  map: fn => Result.Error(error),
  mapError: fn => Result.Error(fn(error)),
});

// Parser Combinator

const ParserContext = (input, result) => ({
  _type: "ParserContext",
  _input: input,
  _result: result,
  map: fn => ParserContext(input, fn(result)),
  fold: fn => fn(input, result),
});

const Parser = fn => ({
  _type: "Parser",
  parse: (input, state) => fn(input),
  andThen: andThenFn =>
    Parser(input =>
      fn(input).fold((input, result) =>
        result.cata({
          Ok: x => andThenFn(x).parse(input),
          Error: _ => ParserContext(input, result),
        }),
      ),
    ),
  map: mapFn => Parser(input => fn(input).map(result => result.map(mapFn))),
  mapError: mapFn =>
    Parser(input => fn(input).map(result => result.mapError(mapFn))),
});

const regex = re =>
  Parser(input =>
    input.length && input[0].match(re)
      ? ParserContext(input.slice(1), Result.Ok(input[0]))
      : ParserContext(
          input,
          Result.Error(`expected to match ${re.toString()}`),
        ),
  );

const string = str =>
  Parser(input =>
    input.length && input.startsWith(str)
      ? ParserContext(input.slice(str.length), Result.Ok(str))
      : ParserContext(input, Result.Error(`expected it to match ${str}`)),
  );
const s = string;

const digit = regex(/\d/).mapError(_ => "expected an int");
const literal = regex(/[a-zA-Z]/).mapError(_ => "expected a literal");
const space = string(" ").mapError(_ => "expected a space");

const succeed = x => Parser(input => ParserContext(input, Result.Ok(x)));

const trace = tag => x => {
  console.log(tag, x);
  return x;
};

const many = parser => {
  const accumulate = (acc, input) =>
    parser.parse(input).fold((nextInput, result) =>
      result.cata({
        Ok: x => accumulate(acc.map(xs => [...xs, x]), nextInput),
        Error: _ => ParserContext(input, acc),
      }),
    );
  return Parser(input => accumulate(Result.Ok([]), input));
};

// const and = (leftParser, rightParser) =>
//   leftParser.andThen(x => rightParser.map(y => [x, y]));

const seq = (...parsers) =>
  parsers.reduce(
    (acc, parser) => acc.andThen(xs => parser.map(y => [...xs, y])),
    succeed([]),
  );

const or = (leftParser, rightParser) =>
  Parser(input =>
    leftParser.parse(input).fold((newInput, result) =>
      result.cata({
        Ok: _ => ParserContext(newInput, result),
        Error: _ => rightParser.parse(input),
      }),
    ),
  );

// Compiler

const betweenParens = parser => seq(
  string("("),
  parser,
  string(")"),
)

const int = many(digit).map(xs => xs.join(""));
const id = many(literal).map(xs => xs.join(""));

const call = () => seq(
  id,
  many(seq(space, expression()).map(xs => xs[1])),
)

const expression = () => or(int, betweenParens(call()))
// const rootExpression = or(int, call())

const parser = seq(
  many(literal).map(xs => xs.join("")),
  many(seq(space, many(int).map(xs => xs.join(""))).map(xs => xs[1])),
).map(([name, args]) => ({ name, args }));

parser.parse("subtract (add 20 32) 10").fold((_, result) =>
  result
    .map(x => {
      if (x.name === "add") {
        return parseInt(x.args[0]) + parseInt(x.args[1]);
      } else if (x.name === "subtract") {
        return parseInt(x.args[0]) - parseInt(x.args[1]);
      } else if (x.name === "divideInt") {
        return Math.round(parseInt(x.args[0]) / parseInt(x.args[1]));
      } else if (x.name === "multiply") {
        return parseInt(x.args[0]) * parseInt(x.args[1]);
      } else if (x.name === "modBy") {
        return parseInt(x.args[0]) % parseInt(x.args[1]);
      } else if (x.name === "exponentBy") {
        return Math.pow(parseInt(x.args[0]), parseInt(x.args[1]));
      }
    })
    .cata({
      Ok: x => console.log(x),
      Error: x => console.log(x),
    }),
);
