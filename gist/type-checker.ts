type Expression = EInt | EVar | EFunc | ECall | EIf;
type EInt =
      { nodeType: "Int", value: number }
type EVar =
      { nodeType: "Var", name: string }
type EFunc =
      { nodeType: "Function", param: string, body: Expression }
type ECall =
      { nodeType: "Call", func: Expression, arg: Expression }
type EIf = {
      nodeType: "If",
      cond: Expression,
      trueBranch: Expression,
      falseBranch: Expression
};


type Type = TNamed | TVar | TFun;
type TNamed = { nodeType: "Type Named", name: string }
type TVar = { nodeType: "Type Var", name: string }
type TFun = { nodeType: "Type Function", from: Type, to: Type };


type Context = {
    next: number; // next type variable to be generated
    env: Env; // mapping of variables in scope to types
}

// a map of type variable names to types assigned to them
type Substitution = {
    [key: string]: Type;
};

// replace the type variables in a type that are
// present in the given substitution and return the
// type with those variables with their substituted values
// eg. Applying the substitution {"a": Bool, "b": Int}
// to a type (a -> b) will give type (Bool -> Int)
function applySubstToType(subst: Substitution, type: Type): Type {
    switch (type.nodeType) {
    case "Type Named": return type;
    case "Type Var":
        if (subst[type.name]) {
            return subst[type.name];
        } else {
            return type;
        }
    case "Type Function":
        return {
            nodeType: "Type Function",
            from: applySubstToType(subst, type.from),
            to: applySubstToType(subst, type.to)
        };
    }
}

/**
 * Add a new binding to the context's environment
 */
function addToContext(ctx: Context, name: string, type: Type): Context {
    return {
        ...ctx,
        env: { 
            ...ctx.env, 
            [name]: type 
        }
    }
}

function newTVar(ctx: Context): Type {
    const newVarNum = ctx.next;
    ctx.next++;
    return {
        nodeType: "Type Var",
        name: `T${newVarNum}`
    };
}

function infer(ctx: Context, e: Expression): [Type, Substitution] {
    const env = ctx.env;
    switch (e.nodeType) {
    case "Int": return [{ nodeType: "Type Named", name: "Int" }, {}];
    case "Var":
        if (env[e.name]) {
            return [env[e.name], {}]
        } else {
            throw `Unbound var ${e.name}`;
        }
    case "Function":
        {
            const newType = newTVar(ctx);
            const newCtx = addToContext(ctx, e.param, newType);
            const [bodyType, subst] = infer(newCtx, e.body);
            const inferredType: Type = {
                nodeType: "Type Function",
                from: applySubstToType(subst, newType),
                to: bodyType
            };
            return [inferredType, subst];
        }
    case "Call":
        {
            const [funcType, s1] = infer(ctx, e.func);
            const [argType, s2] = infer(applySubstToCtx(s1, ctx), e.arg);
            const newVar = newTVar(ctx);
            const s3 = composeSubst(s1, s2);
            const s4 = unify({
                nodeType: "Type Function",
                from: argType,
                to: newVar
            }, funcType);
            const funcType1 = applySubstToType(s4, funcType);
            const s5 = composeSubst(s3, s4);
            const s6 = unify(applySubstToType(s5, (funcType1 as TFun).from), argType);
            const resultSubst = composeSubst(s5, s6);
            return [applySubstToType(resultSubst, (funcType1 as TFun).to), resultSubst];
        }
    }
  default: throw "Unimplemented";
}


function unify(t1: Type, t2: Type): Substitution {
    if (t1.nodeType === "Type Named"
        && t2.nodeType === "Type Named"
        && t2.name === t1.name) {
        return {};
    } else if (t1.nodeType === "Type Var") {
        return varBind(t1.name, t2);
    } else if (t2.nodeType === "Type Var") {
        return varBind(t2.name, t1);
    } else if (t1.nodeType === "Type Function" && t2.nodeType === "Type Function") {
        const s1 = unify(t1.from, t2.from);
        const s2 = unify(
            applySubstToType(s1, t1.to),
            applySubstToType(s1, t2.to)
        );
        return composeSubst(s1, s2);
    } else {
        throw `Type mismatch:\n    Expected ${typeToString(t1)}\n    Found ${typeToString(t2)}`;
    }
}

function composeSubst(s1: Substitution, s2: Substitution): Substitution {
    const result: Substitution = {};
    for (const k in s2) {
        const type = s2[k];
        result[k] = applySubstToType(s1, type);
    };
    return { ...s1, ...result };
}

function varBind(name: string, t: Type): Substitution {
    if (t.nodeType === "Type Var" && t.name === name)  {
        return {};
    } else if (contains(t, name)) {
        throw `Type ${typeToString(t)} contains a reference to itself`;
    } else {
        const subst: Substitution = {};
        subst[name] = t;
        return subst;
    }
}

function contains(t: Type, name: string): boolean {
    switch (t.nodeType) {
    case "Type Named": return false;
    case "Type Var": return t.name === name;
    case "Type Function": return contains(t.from, name) || contains(t.to, name);
    }
}

// apply given substitution to each type in the context's environment
// Doesn't change the input context, but returns a new one
function applySubstToCtx(subst: Substitution, ctx: Context): Context {
    const newContext = {
        ...ctx,
        env: {
            ...ctx.env
        }
    };
    for (const name in newContext.env) {
        const t = newContext.env[name];
        newContext.env[name] = applySubstToType(subst, t);
    }
    return newContext;
}

function v(name: string): Expression {
    return {
        nodeType: "Var",
        name: name
    };
}

function i(value: number): Expression {
    return {
        nodeType: "Int",
        value: value
    };
}

function f(param: string, body: Expression | string): Expression {
    return {
        nodeType: "Function",
        param: param,
        body: typeof body === "string" ? v(body) : body
    };
}

function c(f: Expression | string, ..._args: (Expression | string)[]): Expression {
    const args = _args.map(a => typeof a === "string" ? v(a) : a);
    return args.reduce(
        (func, arg) => ({
            nodeType: "Call",
            func: typeof func === "string" ? v(func) : func,
            arg: typeof arg === "string" ? v(arg) : arg
        }),
        typeof f === "string" ? v(f) : f
    );
}

function tn(name: string): Type {
    return {
        nodeType: "Named",
        name: name
    };
}
function tv(name: string): Type {
    return {
        nodeType: "Var",
        name: name
    };
}
function tfunc(...types: Type[]): Type {
    return types.reduceRight((to, from) => ({
        nodeType: "Function",
        from: from,
        to: to
    }));
}

const initialEnv = {
    "+": tfunc(tn("Int"), tn("Int"), tn("Int"))
};
console.log(
    typeToString(
        infer({
            next: 0,
            env: initialEnv
        },
        c("+", i(1), i(2)),
    )[0]
));
