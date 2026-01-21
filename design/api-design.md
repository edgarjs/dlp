# API Design

API design defines interfaces between components. An API is a contract: it specifies what consumers can request, what providers will deliver, and how errors are communicated.

---

## What API Design Covers

API design answers interface questions:

- What operations does this component expose?
- What inputs does each operation require?
- What outputs does each operation produce?
- What errors can occur and how are they reported?
- What guarantees does the interface make?

This applies to all interfaces, not just web APIs: function signatures, module boundaries, service contracts.

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

Inconsistent:
  create_user(user_data) → user
  add_order(order_data) → order_id
  new_product(product_data, return_full=True) → product
```

---

## Inputs and Outputs

Define what goes in and what comes out.

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

**Input format** — Specify how complex inputs are structured.

```
items format:
  [
    { product_id: 123, quantity: 2 },
    { product_id: 456, quantity: 1 }
  ]
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
list_orders returns summary:
  { id, status, total, created_at }

get_order returns full detail:
  { id, status, total, items, shipping_address, history, ... }
```

---

## Error Handling

Errors are part of the interface. Design them deliberately.

### Error Categories

**Client errors** — The request was invalid; client needs to fix something.

```
- Invalid input (wrong format, missing required field)
- Unauthorized (not authenticated)
- Forbidden (authenticated but not permitted)
- Not found (requested resource does not exist)
- Conflict (operation cannot complete due to current state)
```

**Server errors** — Something went wrong internally; client cannot fix it.

```
- Internal error (unexpected failure)
- Service unavailable (dependency is down)
- Timeout (operation took too long)
```

### Error Response Design

Errors should provide enough information to understand and address the problem:

```
Error response structure:
  {
    error_type: category of error,
    message: human-readable explanation,
    details: additional context (optional),
    field: which input field caused the error (for validation errors)
  }

Example:
  {
    error_type: "validation_error",
    message: "Quantity must be positive",
    field: "items[0].quantity",
    details: { provided_value: -5 }
  }
```

### Error Consistency

Use consistent error patterns across all operations:

```
All operations:
- Return same error structure
- Use same error type vocabulary
- Include actionable information
- Do not expose internal details that could be security risks
```

---

## Versioning

APIs evolve. Plan for change.

### When Versioning Matters

Versioning is essential when:
- Consumers are external or out of your control
- Breaking changes would disrupt active users
- Multiple versions must coexist temporarily

Versioning is optional when:
- All consumers are internal and can update together
- Breaking changes can be coordinated
- The API is not yet stable

### Versioning Strategies

**URL versioning** — Version in the path.

```
/api/v1/orders
/api/v2/orders
```

**Header versioning** — Version in request headers.

```
Accept: application/vnd.api.v2+json
```

**Parameter versioning** — Version as query parameter.

```
/api/orders?version=2
```

### Managing Change

**Backward-compatible changes** (safe):
- Adding new optional parameters
- Adding new fields to responses
- Adding new operations
- Adding new error types

**Breaking changes** (require new version):
- Removing fields or operations
- Changing field types
- Changing required parameters
- Changing error formats

---

## Documentation

Interfaces must be documented to be usable.

### What to Document

For each operation:

```
Operation: create_order

Purpose:
Creates a new order for a user.

Endpoint: POST /orders

Inputs:
  user_id (required): ID of the user placing the order
  items (required): Array of items, each with:
    - product_id: ID of the product
    - quantity: Number to order (1-100)
  shipping_address (required): Delivery address
  notes (optional): Special instructions

Outputs:
  Success (201):
    { id, status, total, created_at }

Errors:
  400 - Invalid input (with validation details)
  401 - Not authenticated
  404 - User not found
  422 - Cannot create order (e.g., out of stock)

Example:
  Request:
    POST /orders
    { user_id: 123, items: [{product_id: 1, quantity: 2}], ... }

  Response:
    { id: 456, status: "pending", total: 29.99, created_at: "..." }
```

---

## API Design Checklist

```
- [ ] All required operations are defined
- [ ] Each operation has a clear, single purpose
- [ ] Inputs are specified with required/optional distinction
- [ ] Input validation rules are documented
- [ ] Output structures are defined
- [ ] Error types and responses are specified
- [ ] Naming is consistent across operations
- [ ] Versioning strategy is determined (if applicable)
- [ ] Documentation covers all operations
- [ ] Security considerations are addressed
```

---

## Common API Design Mistakes

**Exposing internal structure** — API should reflect domain concepts, not implementation details.

```
Poor: get_database_row(table, id)
Better: get_user(id), get_order(id)
```

**Inconsistent naming** — Pick conventions and stick with them.

```
Poor: getUser, create_order, RemoveProduct
Better: get_user, create_order, remove_product (or getUser, createOrder, removeProduct)
```

**Chatty interfaces** — Requiring many calls to accomplish one task.

```
Poor: get_order(id), then get_order_items(id), then get_shipping(id)
Better: get_order(id) returns order with items and shipping
```

**Leaking errors** — Exposing stack traces or internal details in error messages.

```
Poor: "SQLException: constraint violation on orders.user_id_fk"
Better: "Cannot create order: user not found"
```

---

## After API Design

Once APIs are defined:

1. Document all operations, inputs, outputs, and errors
2. Verify APIs support all requirements
3. Review with consumers (if known) for usability
4. Proceed to interface contracts for formal specification
5. Use API documentation as implementation reference

APIs are contracts. Treat changes seriously and communicate them clearly.
