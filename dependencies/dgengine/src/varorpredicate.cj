package dgengine

public enum VarOrPredicate {
    | VaVariable(Variable)
    | VaPredicate(?Predicate)
}
