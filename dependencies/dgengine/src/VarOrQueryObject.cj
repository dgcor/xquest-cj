package dgengine

public enum VarOrQueryObject <: Equatable<VarOrQueryObject> & ToString {
    | VarOrQueryVariable(Variable)
    | VarOrQueryQueryObject(QueryObject)

    public operator func ==(right: VarOrQueryObject): Bool {
        match ((this, right)) {
            case (VarOrQueryVariable(value1), VarOrQueryVariable(value2)) => value1 == value2
            case (VarOrQueryQueryObject(value1), VarOrQueryQueryObject(value2)) => value1 == value2
            case (_, _) => false
        }
    }

    public operator func !=(right: VarOrQueryObject): Bool {
        !(this == right)
    }

    public func isVariable(): Bool {
        match (this) {
            case VarOrQueryVariable(_) => true
            case _ => false
        }
    }

    public func isQueryObject(): Bool {
        match (this) {
            case VarOrQueryQueryObject(_) => true
            case _ => false
        }
    }

    public func toString(): String {
        match (this) {
            case VarOrQueryVariable(value) => value.toString()
            case VarOrQueryQueryObject(value) => value.toString()
        }
    }
}
