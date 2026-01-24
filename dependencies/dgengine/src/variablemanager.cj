package dgengine

import std.collection.*

public class VariableManager {
    private var m_variables: HashMap<String, Variable> = HashMap<String, Variable>()

    // gets variable without tokens. ex: "var"
    public func getVariableNoToken(key: String): ?Variable {
        m_variables.get(key)
    }

    public func getVarOrPropNoToken(queryable: Queryable, key: String): ?Variable {
        let value = m_variables.get(key)
        if (value.isSome()) {
            return value
        }
        return queryable.getProperty(key)
    }

    public func getVarOrProp(queryable: Queryable, value: Variable, default!: Int64): Int64 {
        match (value) {
            case VaInteger(value) => return value
            case VaString(value) =>
                let value2 = getVarOrProp(queryable, value)
                if (let Some(value) <- value2) {
                    match (value) {
                        case VaInteger(value) => return value
                        case _ => ()
                    }
                }
            case _ => ()
        }
        return default
    }

    public func getVarOrProp(queryable: Queryable, value: Variable, default!: Float64): Float64 {
        match (value) {
            case VaDouble(value) => return value
            case VaString(value) =>
                let value2 = getVarOrProp(queryable, value)
                if (let Some(value) <- value2) {
                    match (value) {
                        case VaDouble(value) => return value
                        case _ => ()
                    }
                }
            case _ => ()
        }
        return default
    }

    public func getVarOrProp(queryable: Queryable, key: String): ?Variable {
        if ((key.size > 2) && (Rune(key[0]) == r'%') && (Rune(key[key.size - 1]) == r'%')) {
            let key2 = key[1..key.size - 1]
            return getVarOrPropNoToken(queryable, key2)
        }
        return None
    }

    public func getVarOrProp(queryable: Queryable, value: Variable): Variable {
        match (value) {
            case VaString(key) =>
                if (let Some(value2) <- getVarOrProp(queryable, key)) {
                    return value2
                }
            case _ => ()
        }
        return value
    }

    public func getVarOrPropBoolS(queryable: Queryable, key: String): Bool {
        match (getVarOrProp(queryable, key)) {
            case Some(value) => value.toBool()
            case None => false
        }
    }

    public func getVarOrPropBoolV(queryable: Queryable, value: Variable): Bool {
        match (value) {
            case VaString(key) => getVarOrPropBoolS(queryable, key)
            case _ => value.toBool()
        }
    }

    public func getVarOrPropDoubleS(queryable: Queryable, key: String): Float64 {
        match (getVarOrProp(queryable, key)) {
            case Some(value) => value.toDouble()
            case None => 0.0
        }
    }

    public func getVarOrPropDoubleV(queryable: Queryable, value: Variable): Float64 {
        match (value) {
            case VaString(key) => getVarOrPropDoubleS(queryable, key)
            case _ => value.toDouble()
        }
    }

    public func getVarOrPropInt64S(queryable: Queryable, key: String): Int64 {
        match (getVarOrProp(queryable, key)) {
            case Some(value) => value.toInt64()
            case None => 0
        }
    }

    public func getVarOrPropInt64V(queryable: Queryable, value: Variable): Int64 {
        match (value) {
            case VaString(key) => getVarOrPropInt64S(queryable, key)
            case _ => value.toInt64()
        }
    }

    public func getVarOrPropStringS(queryable: Queryable, key: String, outStr: Box<String>): Bool {
        if ((key.size > 2) && (Rune(key[0]) == r'%') && (Rune(key[key.size - 1]) == r'%')) {
            let key2 = key[1..key.size - 1]
            if (let Some(variable) <- getVariableNoToken(key2)) {
                match (variable) {
                    case VaString(str) =>
                        if (let Some(queryVar) <- queryable.getProperty(str)) {
                            outStr.value = queryVar.toString()
                        } else {
                            outStr.value = str
                        }
                    case _ => outStr.value = variable.toString()
                }
                return true
            } else if (let Some(queryVar) <- queryable.getProperty(key2)) {
                outStr.value = queryVar.toString()
                return true
            }
        }
        outStr.value = key
        return false
    }

    public func getVarOrPropStringS(queryable: Queryable, key: String): String {
        var str = Box(String())
        getVarOrPropStringS(queryable, key, str)
        return str.value
    }

    public func getVarOrPropStringV(queryable: Queryable, value: Variable): String {
        match (value) {
            case VaString(key) => getVarOrPropStringS(queryable, key)
            case _ => value.toString()
        }
    }

    // no tokens in key
    public func clearVariable(key: String): Unit {
        m_variables.remove(key)
    }

    // no tokens in key
    public func setVariable(key: String, value: Variable): Unit {
        m_variables.add(key, value)
    }

    public func saveVariables(filePath: String, varNames: Array<String>): Unit {
        if (varNames.isEmpty() == true) {
            return
        }
        let variablesToSave = ArrayList<(String, Variable)>()
        for (name in varNames) {
            if (let Some(value) <- m_variables.get(name)) {
                variablesToSave.add((name, value))
            }
        }
        if (variablesToSave.isEmpty() == false) {
            JsonUtils.saveToFile(filePath, "variable", variablesToSave.iterator())
        }
    }
}
