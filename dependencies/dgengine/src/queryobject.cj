package dgengine

public enum QueryObject <: Equatable<QueryObject> & ToString {
    | ObjQueryable(Queryable)
    | ObjQueryableIndex(Queryable, Int64)

    public operator func ==(right: QueryObject): Bool {
        match ((this, right)) {
            case (ObjQueryable(value1), ObjQueryable(value2)) => isObjEq(value1, value2)
            case (ObjQueryableIndex(value1, idx1), ObjQueryableIndex(value2, idx2)) => isObjEq(value1, value2) &&
                idx1 == idx2
            case (_, _) => false
        }
    }

    public operator func !=(right: QueryObject): Bool {
        !(this == right)
    }

    public func isQueryable(): Bool {
        match (this) {
            case ObjQueryable(_) => true
            case _ => false
        }
    }

    public func isQueryableIndex(): Bool {
        match (this) {
            case ObjQueryableIndex(_, _) => true
            case _ => false
        }
    }

    public func getQueryable(): Queryable {
        match (this) {
            case ObjQueryable(value) => value
            case ObjQueryableIndex(value, _) => value
        }
    }

    public func getIndex(defaultIndex: Int64): Int64 {
        match (this) {
            case ObjQueryableIndex(_, index) => index
            case _ => defaultIndex
        }
    }

    public func toString(): String {
        match (this) {
            case ObjQueryable(_) => "(ObjQueryable)"
            case ObjQueryableIndex(_, value2) => "(ObjQueryableIndex, ${value2})"
        }
    }
}
