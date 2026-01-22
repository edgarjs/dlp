# Interface Contracts

Interface contracts formalize the agreements between components. A contract specifies precisely what a component promises to do and what it requires from its callers.

---

## What Contracts Define

Contracts make implicit assumptions explicit:

- **Preconditions** — What must be true before invoking the operation
- **Postconditions** — What will be true after the operation completes
- **Invariants** — What is always true about the component's state
- **Error conditions** — What happens when preconditions are not met

---

## Why Contracts Matter

Without contracts, assumptions remain implicit:

```
Implicit assumption:
  Developer A assumes get_user returns null for missing users
  Developer B assumes get_user throws an exception for missing users
  Bug: Code breaks when these assumptions meet

With contract:
  Contract specifies: get_user returns null if user does not exist
  Both developers code against the same expectation
```

Contracts:
- Prevent integration failures
- Document expected behavior
- Enable independent development
- Clarify responsibility for validation
- Support testing at boundaries

---

## Preconditions

Preconditions are requirements that must be satisfied before calling an operation. The caller is responsible for ensuring preconditions hold.

### Specifying Preconditions

```
Operation: transfer_funds(from_account, to_account, amount)

Preconditions:
- from_account exists and is active
- to_account exists and is active
- amount is positive
- from_account has sufficient balance (balance >= amount)
- from_account and to_account are different
```

### Precondition Checking

Who checks preconditions?

**Defensive approach** — The operation checks and returns errors.

```
transfer_funds(from, to, amount):
  if from_account not found:
    raise AccountNotFoundError
  if balance < amount:
    raise InsufficientFundsError
  ... proceed with transfer
```

**Contract approach** — The caller ensures preconditions; operation may assume they hold.

```
caller:
  if account.balance >= amount:
    transfer_funds(from, to, amount)

transfer_funds(from, to, amount):
  ... proceed directly (preconditions assumed)
```

**Practical approach** — Check critical preconditions defensively; trust others.

```
transfer_funds(from, to, amount):
  assert amount > 0, "Precondition: amount must be positive"
  assert from != to, "Precondition: accounts must differ"
  ... proceed with transfer (checks balance internally for safety)
```

---

## Postconditions

Postconditions are guarantees about what will be true after an operation completes successfully.

### Specifying Postconditions

```
Operation: transfer_funds(from_account, to_account, amount)

Postconditions (on success):
- from_account.balance decreased by amount
- to_account.balance increased by amount
- Total balance across both accounts unchanged
- Transaction record created with timestamp
- Both accounts remain in valid state

Postconditions (on failure):
- Neither account balance changed
- No transaction record created
- Error returned with reason
```

### Postcondition Strength

Stronger postconditions are more useful but harder to guarantee:

```
Weak postcondition:
  "Order status is updated"

Stronger postcondition:
  "Order status is set to 'shipped', shipment tracking number is recorded,
   notification email is queued, updated_at reflects current time"
```

Specify postconditions at the level of detail consumers need to rely on.

---

## Invariants

Invariants are conditions that must always be true about a component or entity.

### Specifying Invariants

```
Entity: Order

Invariants:
- order.total equals sum of order_items amounts
- order.status is one of: pending, confirmed, shipped, delivered, cancelled
- order.created_at <= order.updated_at
- if status is 'delivered', shipped_at is set
- order always has at least one order_item (or is cancelled)
```

### Invariant Enforcement

Invariants should be maintained by all operations:

```
add_item_to_order(order, item):
  precondition: order.status is pending
  postcondition: order.total equals sum of items (invariant preserved)

remove_item_from_order(order, item):
  precondition: order has more than one item (or will be cancelled)
  postcondition: order.total equals sum of items (invariant preserved)
```

---

## Error Conditions

Contracts specify what happens when things go wrong. See [error-handling.md](../development/error-handling.md) for comprehensive error handling strategies.

### Error Specification

Document error conditions as part of the contract:

```
Operation: withdraw(account, amount)

Error conditions:
- If account.balance < amount: raise InsufficientFundsError
- If account.status is frozen: raise AccountFrozenError

On error:
- Account balance unchanged
- Error contains: reason, current_balance (for insufficient funds)
```

### Error vs. Precondition Violation

- **Precondition violation** — Caller made a mistake (programming error). Example: `withdraw(account, -50)` violates precondition.
- **Error condition** — Valid request that cannot be fulfilled. Example: `withdraw(account, 100)` when balance is 50.

---

## Contract Documentation Format

Document contracts consistently:

```
Contract: ComponentName.operation_name

Purpose:
[Brief description of what the operation does]

Signature:
operation_name(param1: type, param2: type) -> return_type

Preconditions:
- [condition that must be true before calling]
- [another condition]

Postconditions:
- [condition guaranteed after successful completion]
- [another guarantee]

Error conditions:
- [condition]: [error type] — [what happens]
- [condition]: [error type] — [what happens]

Invariants preserved:
- [invariant this operation maintains]

Example:
[Usage example showing contract in action]
```

### Example Contract

```
Contract: AccountService.transfer

Purpose:
Transfers funds between two accounts atomically.

Signature:
transfer(from_id: int, to_id: int, amount: decimal) -> Transaction

Preconditions:
- from_id refers to an existing, active account
- to_id refers to an existing, active account
- from_id != to_id
- amount > 0

Postconditions:
- from_account.balance decreased by amount
- to_account.balance increased by amount
- Transaction record created and returned
- from_account and to_account both remain valid

Error conditions:
- from_account.balance < amount: InsufficientFundsError
  (neither balance changed, no transaction created)
- from_account.status is frozen: AccountFrozenError
  (neither balance changed, no transaction created)

Invariants preserved:
- Sum of all account balances unchanged
- All accounts have non-negative balance

Example:
  tx = account_service.transfer(123, 456, 100.00)
  assert tx.amount == 100.00
  assert account_123.balance decreased by 100.00
  assert account_456.balance increased by 100.00
```

---

## Contract Design Guidelines

### Be Precise

Vague contracts are not contracts:

```
Vague: "Updates the user"
Precise: "Sets user.email to new_email; sets user.updated_at to current time;
         user.id unchanged; returns updated user object"
```

### Be Complete

Cover all outcomes:

```
Incomplete:
  Postcondition: "Returns the user"

Complete:
  Postcondition (success): "Returns user object with all fields populated"
  Postcondition (not found): "Returns null"
  Error (invalid id): "Raises InvalidIdError"
```

### Be Realistic

Do not promise what you cannot guarantee:

```
Unrealistic: "Email delivered within 1 second"
Realistic: "Email queued for delivery; delivery not guaranteed"
```

---

## Contracts Checklist

```
- [ ] All component interfaces have documented contracts
- [ ] Preconditions are clearly stated
- [ ] Postconditions cover success cases
- [ ] Error conditions are specified
- [ ] Invariants are identified
- [ ] Contracts are precise enough to test against
- [ ] Contracts are realistic (can be implemented)
- [ ] Responsibility for validation is clear
```

---

## After Contracts

Once contracts are defined:

1. Use contracts as the authoritative interface specification
2. Implement to satisfy contracts
3. Test against contracts (not just implementation)
4. Update contracts when interfaces change
5. Proceed to design review

Contracts enable teams to work independently against shared agreements.
