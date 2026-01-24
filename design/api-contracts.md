# API Contracts

Defines interfaces between components. An API specifies what consumers can request, what providers deliver, and what guarantees are made. Contracts formalize these agreements with preconditions, postconditions, and invariants.

> **Required Format:** API contracts MUST be documented using OpenAPI 3.1 specification (YAML format). Use the template at `templates/api-contract.yml` as a starting point. OpenAPI provides machine-readable contracts that enable automated validation, documentation generation, and client SDK generation.

---

## Designing Operations

Operations are the actions a component exposes.

### Identifying Operations

Operations emerge from requirements and architecture:

```
Requirement: "Users can place orders"
Component: Order Service

Operations needed:
- Create order from cart
- Retrieve order by ID
- List orders for user
- Update order status
- Cancel order
```

### Operation Design Principles

**Clear purpose** — Each operation does one thing. Its name reflects its purpose.

```
Poor: process_order(order, action)  — action determines behavior
Better: create_order(order), cancel_order(order_id), ship_order(order_id)
```

**Minimal interface** — Request only what is needed; return only what is useful.

```
Poor: get_user(id) returns entire user object with all history
Better: get_user(id) returns user profile; get_user_orders(id) returns orders
```

**Consistent patterns** — Similar operations work similarly.

```
Consistent:
  create_user(user_data) → user
  create_order(order_data) → order
  create_product(product_data) → product
```

---

## Inputs and Outputs

### Input Design

**Required vs. optional** — Distinguish clearly between parameters that must be provided and those that have defaults.

```
create_order(
  user_id,          — required: who is placing the order
  items,            — required: what is being ordered
  shipping_address, — required: where to deliver
  notes = null,     — optional: special instructions
  priority = normal — optional: defaults to normal
)
```

**Validation boundaries** — Define what inputs are valid.

```
user_id: must be a positive integer, must reference an existing user
items: must be non-empty list of {product_id, quantity}
quantity: must be positive integer, max 100
```

### Output Design

**Success responses** — What does the operation return when it succeeds?

```
create_order success response:
  {
    id: newly created order ID,
    status: "pending",
    total: calculated total amount,
    created_at: timestamp
  }
```

**Partial information** — Return what consumers need, not everything available.

```
list_orders returns summary: { id, status, total, created_at }
get_order returns full detail: { id, status, total, items, shipping_address, ... }
```

---

## Contract Specification

Contracts make implicit assumptions explicit:

- **Preconditions** — What must be true before invoking the operation
- **Postconditions** — What will be true after the operation completes
- **Invariants** — What is always true about the component's state
- **Error conditions** — What happens when preconditions are not met

### Why Contracts Matter

```
Without contract:
  Developer A assumes get_user returns null for missing users
  Developer B assumes get_user throws an exception
  Bug: Code breaks when these assumptions meet

With contract:
  Contract specifies: get_user returns null if user does not exist
  Both developers code against the same expectation
```

---

## Preconditions

Preconditions are requirements that must be satisfied before calling an operation. The caller is responsible for ensuring preconditions hold.

```
Operation: transfer_funds(from_account, to_account, amount)

Preconditions:
- from_account exists and is active
- to_account exists and is active
- amount is positive
- from_account has sufficient balance (balance >= amount)
- from_account and to_account are different
```

### Precondition Checking Approaches

| Approach  | Description                         | When to Use                    |
| --------- | ----------------------------------- | ------------------------------ |
| Defensive | Operation checks and returns errors | Public APIs, untrusted callers |
| Contract  | Caller ensures; operation assumes   | Internal APIs, trusted callers |
| Practical | Check critical ones; trust others   | Most situations                |

---

## Postconditions

Postconditions are guarantees about what will be true after an operation completes successfully.

```
Operation: transfer_funds(from_account, to_account, amount)

Postconditions (on success):
- from_account.balance decreased by amount
- to_account.balance increased by amount
- Total balance across both accounts unchanged
- Transaction record created with timestamp

Postconditions (on failure):
- Neither account balance changed
- No transaction record created
- Error returned with reason
```

Stronger postconditions are more useful but harder to guarantee. Specify at the level of detail consumers need.

---

## Invariants

Invariants are conditions that must always be true about a component or entity.

```
Entity: Order

Invariants:
- order.total equals sum of order_items amounts
- order.status is one of: pending, confirmed, shipped, delivered, cancelled
- order.created_at <= order.updated_at
- if status is 'delivered', shipped_at is set
- order always has at least one order_item (or is cancelled)
```

Invariants should be maintained by all operations.

---

## Error Handling

Errors are part of the interface. For comprehensive strategies, see [error-handling.md](../development/error-handling.md).

### Error Response Structure

```
{
  error_type: category of error,
  message: human-readable explanation,
  details: additional context (optional),
  field: which input field caused the error (for validation errors)
}
```

### Error vs. Precondition Violation

| Type                   | Description                               | Example                                     |
| ---------------------- | ----------------------------------------- | ------------------------------------------- |
| Precondition violation | Caller made a mistake (programming error) | `withdraw(account, -50)`                    |
| Error condition        | Valid request that cannot be fulfilled    | `withdraw(account, 100)` when balance is 50 |

---

## Versioning

APIs evolve. Plan for change.

### When Versioning Matters

Versioning is essential when consumers are external, breaking changes would disrupt users, or multiple versions must coexist.

Versioning is optional when all consumers are internal and can update together.

### Versioning Strategies

| Strategy  | Example                               | Notes                 |
| --------- | ------------------------------------- | --------------------- |
| URL       | `/api/v1/orders`                      | Most common, explicit |
| Header    | `Accept: application/vnd.api.v2+json` | Cleaner URLs          |
| Parameter | `/api/orders?version=2`               | Simple but less clean |

### Managing Change

**Backward-compatible** (safe): Adding optional parameters, new fields, new operations.

**Breaking** (require new version): Removing fields/operations, changing types, changing required parameters.

---

## Documentation

For each operation, document:

```
Operation: create_order

Purpose: Creates a new order for a user.
Endpoint: POST /orders

Inputs:
  user_id (required): ID of the user
  items (required): Array of {product_id, quantity}
  shipping_address (required): Delivery address
  notes (optional): Special instructions

Outputs:
  Success (201): { id, status, total, created_at }

Errors:
  400 - Invalid input
  401 - Not authenticated
  404 - User not found
  422 - Cannot create order

Example:
  Request: POST /orders { user_id: 123, items: [...] }
  Response: { id: 456, status: "pending", total: 29.99 }
```

---

## Contract Documentation Format

```
Contract: ComponentName.operation_name

Purpose: [Brief description]

Signature:
operation_name(param1: type, param2: type) -> return_type

Preconditions:
- [condition that must be true before calling]

Postconditions:
- [condition guaranteed after successful completion]

Error conditions:
- [condition]: [error type] — [what happens]

Invariants preserved:
- [invariant this operation maintains]
```

---

## Guidelines

**Be precise** — Vague contracts are not contracts.

```
Vague: "Updates the user"
Precise: "Sets user.email to new_email; sets user.updated_at to current time"
```

**Be complete** — Cover all outcomes (success, not found, errors).

**Be realistic** — Do not promise what you cannot guarantee.

---

## Checklist

```
Operations:
- [ ] All required operations are defined
- [ ] Each operation has a clear, single purpose
- [ ] Inputs specified with required/optional distinction
- [ ] Output structures are defined
- [ ] Naming is consistent across operations

Contracts:
- [ ] Preconditions are clearly stated
- [ ] Postconditions cover success cases
- [ ] Error conditions are specified
- [ ] Invariants are identified
- [ ] Contracts are precise enough to test against

Quality:
- [ ] Error types and responses are specified
- [ ] Versioning strategy determined (if applicable)
- [ ] Documentation covers all operations
- [ ] Security considerations addressed
```

---

## Common Mistakes

**Exposing internal structure** — API should reflect domain concepts, not implementation.

```
Poor: get_database_row(table, id)
Better: get_user(id), get_order(id)
```

**Inconsistent naming** — Pick conventions and stick with them.

```
Poor: getUser, create_order, RemoveProduct
Better: get_user, create_order, remove_product
```

**Chatty interfaces** — Requiring many calls to accomplish one task.

```
Poor: get_order(id), then get_order_items(id), then get_shipping(id)
Better: get_order(id) returns order with items and shipping
```

---

## After API Contracts

Once APIs and contracts are defined:

1. Use contracts as the authoritative interface specification
2. Implement to satisfy contracts
3. Test against contracts (not just implementation)
4. Update contracts when interfaces change

APIs are contracts. Treat changes seriously and communicate them clearly.
