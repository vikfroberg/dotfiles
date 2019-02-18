console.log(
  "program",
  parse("id x = x\nid2 x = x")
)

function parse(str) {
  return {
    type: "Program",
    module: "Main",
    definitions: many(definition, str),
  }
}

function many(fn, str) {
  return definition(str, [])
}

function definition(str) {
  const fun = match([
    identifier,
    zeroOrMore(match(space, identifier)),
    equal,
    oneOrMore(whitespace),
  ], ([ id, args, _, _]) => ({ id, args }))

  const expr = match([ identifier ], ([ id ]) => ({ type: "Expression", val: { type: "Identifier", value: id } }))

  const def = match([ fun, expr ], ([ fun, expr ]) => ({ type: "Definition", name: fun.id, args: fun.args, expr: expr }))

  return [ def, ...definition(str) ]
}
