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
type TNamed = { nodeType: "Named", name: string }
type TVar = { nodeType: "Var", name: string }
type TFun = { nodeType: "Function", from: Type, to: Type };


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
    case "Named": return type;
    case "Var":
        if (subst[type.name]) {
            return subst[type.name];
        } else {
            return type;
        }
    case "Function":
        return {
            nodeType: "Function",
            from: applySubstToType(subst, type.from),
            to: applySubstToType(subst, type.to)
        };
    }
}

/**
 * Add a new binding to the context's environment
 */
function addToContext(ctx: Context, name: string, type: Type): Context {
    const newEnv = Object.assign({}, ctx, {
        env: Object.assign({}, ctx.env)
    };
    newEnv.env[name] = type;
    return newEnv;
}

function newTVar(ctx: Context): Type {
    const newVarNum = ctx.next;
    ctx.next++;
    return {
        nodeType: "Var",
        name: `T${newVarNum}`
    };
}

function infer(ctx: Context, e: Expression): [Type, Substitution] {
    const env = ctx.env;
    switch (e.nodeType) {
    case "Int": return [{ nodeType: "Named", name: "Int" }, {}];
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
                nodeType: "Function",
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
                nodeType: "Function",
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
    if (t1.nodeType === "Named"
        && t2.nodeType === "Named"
        && t2.name === t1.name) {
        return {};
    } else if (t1.nodeType === "Var") {
        return varBind(t1.name, t2);
    } else if (t2.nodeType === "Var") {
        return varBind(t2.name, t1);
    } else if (t1.nodeType === "Function" && t2.nodeType === "Function") {
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
    if (t.nodeType === "Var" && t.name === name)  {
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
    case "Named": return false;
    case "Var": return t.name === name;
    case "Function": return contains(t.from, name) || contains(t.to, name);
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

