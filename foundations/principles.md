# Principles

These core principles guide every decision throughout the software development process. They are not rigid rules but heuristics—each has contexts where it applies strongly and contexts where it should be relaxed or violated.

Understanding when to apply a principle is as important as understanding the principle itself.

---

## YAGNI — You Ain't Gonna Need It

### Definition

Do not build functionality until it is actually needed. Avoid implementing features based on speculation about future requirements.

### When to Apply

- When tempted to add "just in case" parameters or configuration options
- When designing abstractions for hypothetical future use cases
- When building infrastructure for features not yet requested
- When adding flexibility that no current requirement demands

### When to Violate

- When the cost of adding something later is dramatically higher than adding it now (rare in software)
- When regulatory or contractual obligations require specific capabilities upfront
- When a requirement is confirmed but scheduled for a later phase

### Example

```
Situation: Building a user registration system

YAGNI violation:
  create_user(name, email, phone, fax, pager, secondary_email,
              preferred_contact_method, timezone, locale, ...)
  "We might need these fields someday"

YAGNI applied:
  create_user(name, email)
  Add other fields when requirements actually call for them
```

### The Cost of Violation

Speculative features:
- Must be maintained even if never used
- Add complexity to testing and documentation
- Create decision paralysis for future developers
- Often guess wrong about actual future needs

---

## KISS — Keep It Super Simple

### Definition

Given multiple solutions that satisfy requirements, prefer the simplest one. Complexity should be introduced only when simpler approaches demonstrably fail.

### When to Apply

- When choosing between architectural approaches
- When designing data structures
- When writing individual functions or methods
- When selecting dependencies or libraries

### When to Violate

- When the simple solution has unacceptable performance characteristics (measured, not assumed)
- When the simple solution creates security vulnerabilities
- When domain complexity genuinely requires a sophisticated model
- When the "simple" solution would require extensive duplication

### Example

```
Situation: Need to track whether a user has completed onboarding

Complex approach:
  create OnboardingStateMachine with states:
    NOT_STARTED, IN_PROGRESS, STEP_1_COMPLETE, STEP_2_COMPLETE,
    PAUSED, RESUMED, COMPLETED, SKIPPED
  with transitions and event handlers for each state change

Simple approach:
  add field: user.onboarding_completed = true/false

Start with the boolean. Introduce the state machine only when
requirements demonstrate the boolean is insufficient.
```

### Recognizing Unnecessary Complexity

Signs that complexity may be unjustified:
- The explanation of how something works is longer than the problem statement
- You need diagrams to explain a single function
- New team members consistently struggle with a component
- Edge cases in your solution outnumber actual use cases

---

## DRY — Don't Repeat Yourself

### Definition

Every piece of knowledge should have a single, authoritative representation in the system. When you change something, you should only need to change it in one place.

### When to Apply

- When the same business logic appears in multiple locations
- When configuration values are hardcoded in multiple places
- When data transformations are duplicated across the codebase
- When the same validation rules exist in multiple forms

### When to Violate

DRY is frequently misapplied. Duplication is acceptable and often preferable when:

- **Code is similar but serves different purposes** — Two functions that happen to look alike today but represent different concepts should remain separate. They will likely diverge as requirements evolve.

- **Coupling would be worse than duplication** — If removing duplication requires creating dependencies between unrelated modules, keep the duplication.

- **The duplication is trivial** — Three lines of similar code in two places does not justify a shared abstraction. The cognitive overhead of indirection can exceed the cost of duplication.

- **The abstraction is unclear** — If you cannot name the shared concept clearly, the duplication might be coincidental rather than meaningful.

### Example

```
Situation: Two functions format dates, one for display, one for API responses

Coincidental duplication (keep separate):
  format_date_for_display(date):
    return date formatted as "January 5, 2025"

  format_date_for_api(date):
    return date formatted as "2025-01-05"

  These look similar but serve different purposes and will
  evolve independently. Forcing them to share code creates coupling.

Meaningful duplication (extract):
  Multiple places calculate tax using the same formula:

  order_tax = order.subtotal * 0.08
  invoice_tax = invoice.amount * 0.08
  estimate_tax = estimate.total * 0.08

  Extract: calculate_tax(amount) = amount * TAX_RATE
  The tax rate is a single piece of knowledge that should live
  in one place.
```

### The Rule of Three

A useful heuristic: tolerate duplication until you see the same pattern three times. By the third occurrence, you have enough information to understand what varies and what stays constant, making abstraction safer.

---

## Separation of Concerns

### Definition

Organize code so that each component addresses a single, well-defined concern. Components should have minimal knowledge of each other's internal workings.

### When to Apply

- When designing module or package boundaries
- When a function or class starts doing "too many things"
- When changes to one feature consistently require changes to unrelated code
- When testing a component requires extensive setup of unrelated systems

### When to Violate

- When separation would require passing excessive data between components
- When the "concerns" are so intertwined that separation creates artificial boundaries
- When performance requirements demand tighter coupling
- In simple scripts or tools where the overhead of separation exceeds its benefits

### Example

```
Situation: Processing a customer order

Mixed concerns:
  process_order(order):
    validate order fields
    check inventory in database
    calculate prices and discounts
    charge payment via payment gateway
    update inventory in database
    send confirmation email
    log analytics event

Separated concerns:
  validate_order(order)           -- validation logic
  check_inventory(order.items)    -- inventory domain
  calculate_total(order)          -- pricing domain
  process_payment(order, total)   -- payment integration
  update_inventory(order.items)   -- inventory domain
  notify_customer(order)          -- notification system
  record_analytics(order)         -- analytics system

  process_order(order):
    orchestrates the above, contains no domain logic itself
```

### Finding the Right Boundaries

Good separation feels natural—components have clear names, focused responsibilities, and minimal interfaces. If you struggle to name a component or its interface is sprawling, the boundaries may be wrong.

---

## Fail Fast, Fail Clearly

### Definition

When something goes wrong, detect it as early as possible and report it with enough information to diagnose the problem. Do not let invalid states propagate through the system.

### When to Apply

- When validating inputs at system boundaries
- When assumptions about data or state could be violated
- When errors could cascade into harder-to-diagnose failures
- When debugging time is more costly than slightly verbose error handling

### When to Violate

- When graceful degradation is explicitly required (user-facing features that should partially work)
- When the "failure" is actually an expected alternative path
- When failing fast would create a poor user experience for recoverable situations
- In exploratory or fault-tolerant contexts where partial results are valuable

### Example

```
Situation: Function receives a user ID to process

Fail slow (problematic):
  process_user(user_id):
    user = fetch_user(user_id)          -- returns null if not found
    orders = fetch_orders(user.id)      -- crashes: null.id

  The actual error (user not found) is obscured by a secondary error

Fail fast (preferred):
  process_user(user_id):
    user = fetch_user(user_id)
    if user is null:
      raise Error("User not found: {user_id}")
    orders = fetch_orders(user.id)

  Error is detected immediately with actionable information
```

### Clear Error Messages

A good error message answers:
- **What** went wrong (the immediate problem)
- **Where** it went wrong (location in code or data)
- **Why** it matters (what operation was being attempted)
- **What** values were involved (for debugging)

```
Poor:   "Invalid input"
Better: "User ID must be positive integer, received: -5"
Best:   "Cannot fetch user profile: User ID must be positive integer,
         received: -5 (in process_order for order #12345)"
```

---

## SOLID Principles

SOLID is a set of five principles for object-oriented design that promote maintainable, flexible code. While originating in OOP, the underlying ideas apply broadly.

### Single Responsibility Principle (SRP)

A module should have one, and only one, reason to change.

```
Problem:
  UserService:
    - authenticate users
    - send emails
    - generate reports
    - manage database connections

  Changes to email formatting require touching the same class
  that handles authentication.

Solution:
  AuthenticationService: handles login/logout
  EmailService: handles sending emails
  ReportGenerator: handles report creation
  DatabaseConnection: handles DB connections

  Each component changes for exactly one reason.
```

### Open/Closed Principle (OCP)

Software entities should be open for extension but closed for modification.

```
Problem:
  calculate_discount(customer):
    if customer.type == "gold":
      return 0.20
    if customer.type == "silver":
      return 0.10
    if customer.type == "bronze":
      return 0.05
    return 0

  Adding a new customer type requires modifying existing code.

Solution:
  Each customer type defines its own discount:
    GoldCustomer.discount() -> 0.20
    SilverCustomer.discount() -> 0.10

  New types extend behavior without changing existing code.
```

### Liskov Substitution Principle (LSP)

Subtypes must be substitutable for their base types without altering program correctness.

```
Problem:
  Rectangle has width and height
  Square extends Rectangle
  Square.set_width(w) also sets height to w

  Code expecting Rectangle behavior breaks:
    rect = get_rectangle()  // might return Square
    rect.set_width(5)
    rect.set_height(10)
    assert rect.area() == 50  // fails if Square!

Solution:
  Don't make Square extend Rectangle. Model them as separate
  types or use a common Shape interface that doesn't promise
  independent width/height.
```

### Interface Segregation Principle (ISP)

Clients should not be forced to depend on interfaces they do not use.

```
Problem:
  Worker interface:
    - work()
    - eat()
    - sleep()

  RobotWorker must implement eat() and sleep() even though
  robots don't eat or sleep.

Solution:
  Workable interface: work()
  Eatable interface: eat()
  Sleepable interface: sleep()

  HumanWorker implements all three
  RobotWorker implements only Workable
```

### Dependency Inversion Principle (DIP)

High-level modules should not depend on low-level modules. Both should depend on abstractions.

```
Problem:
  OrderProcessor directly creates MySQLDatabase
  Changing to PostgreSQL requires changing OrderProcessor

  OrderProcessor:
    db = new MySQLDatabase()
    db.save(order)

Solution:
  OrderProcessor depends on Database interface
  Specific database is injected

  OrderProcessor:
    constructor(database: Database)
    database.save(order)

  Can use MySQLDatabase, PostgreSQLDatabase, or TestDatabase
  without changing OrderProcessor.
```

### When SOLID Applies Less

- Simple scripts or one-off tools
- Prototypes exploring a problem space
- When the overhead of abstraction exceeds the benefit
- Codebases with no anticipated change

---

## Composition Over Inheritance

### Definition

Favor composing objects from smaller, focused components rather than building deep inheritance hierarchies. Inherit for "is-a" relationships; compose for "has-a" or "uses-a" relationships.

### When to Apply

- When you find yourself inheriting just to reuse code
- When inheritance hierarchies are more than 2-3 levels deep
- When subclasses override most of the parent's behavior
- When you need to combine behaviors from multiple sources

### When to Violate

- When there is a genuine "is-a" relationship (a Dog is an Animal)
- When a framework requires inheritance
- When the inheritance hierarchy is shallow and stable
- When polymorphism through inheritance simplifies the design

### Example

```
Inheritance approach (problematic):
  Bird
    ├── FlyingBird
    │     ├── Sparrow
    │     └── Eagle
    └── NonFlyingBird
          ├── Penguin
          └── Ostrich

  What about a Duck that swims and flies?
  What about a Penguin that swims but doesn't fly?
  Hierarchy becomes tangled.

Composition approach:
  Bird has:
    - FlyingBehavior (CanFly or CannotFly)
    - SwimmingBehavior (CanSwim or CannotSwim)

  Duck = Bird + CanFly + CanSwim
  Penguin = Bird + CannotFly + CanSwim
  Sparrow = Bird + CanFly + CannotSwim

  Behaviors can be mixed freely without hierarchy constraints.
```

### Signs You Need Composition

- You're creating subclasses just to override one method
- You want to share code between classes that aren't related
- Your inheritance tree has multiple "special case" branches
- You're fighting the type system to make inheritance work

---

## Law of Demeter

### Definition

A method should only talk to its immediate friends, not to strangers. More specifically, a method M of object O should only call methods of:
- O itself
- Objects passed as arguments to M
- Objects created within M
- O's direct component objects

### When to Apply

- When you see chains like `a.getB().getC().doSomething()`
- When changes to one class ripple through many others
- When testing requires extensive mocking of nested objects
- When understanding code requires tracing through multiple objects

### When to Violate

- Fluent interfaces designed for chaining (builders, streams)
- Data structures where traversal is the point (trees, graphs)
- When strict adherence creates excessive wrapper methods
- In simple scripts where the cost of indirection exceeds benefits

### Example

```
Violation (reaching through objects):
  process_order(order):
    street = order.customer.address.street
    city = order.customer.address.city
    send_package(street, city)

  This method knows the internal structure of Customer and Address.
  Changes to Address break this code.

Following Law of Demeter:
  process_order(order):
    shipping_address = order.get_shipping_address()
    send_package(shipping_address)

  Order provides what's needed. Internal structure is hidden.

Alternative (tell, don't ask):
  process_order(order):
    order.ship()

  Even better: tell the order to ship itself rather than
  extracting data to do shipping externally.
```

### "Tell, Don't Ask"

A related principle: instead of asking an object for data and then acting on it, tell the object what you need done. This naturally follows the Law of Demeter.

```
Ask (violates):
  if customer.account.balance >= amount:
    customer.account.balance -= amount

Tell (follows):
  customer.charge(amount)
  // Customer knows how to handle its own account
```

---

## Applying Principles Together

These principles sometimes tension with each other:

- **YAGNI vs. SOLID** — SOLID encourages abstractions and interfaces, but YAGNI warns against speculative design
- **DRY vs. KISS** — Eliminating duplication can introduce complex abstractions
- **Composition vs. KISS** — Composition adds indirection; sometimes inheritance is simpler
- **Law of Demeter vs. practicality** — Strict adherence can create excessive wrapper methods
- **Fail Fast vs. KISS** — Comprehensive error handling adds code complexity

When principles conflict, consider:

1. **What is the cost of being wrong?** If getting it wrong is cheap to fix, prefer YAGNI and KISS. If getting it wrong is expensive, invest in separation and error handling.

2. **What does the requirement actually demand?** Let actual needs—not hypothetical ones—guide the balance.

3. **What would make this code easier to change?** The principles exist to support maintainability. When in doubt, ask which choice makes future changes easier.

See [decision-making.md](decision-making.md) for a framework on resolving these trade-offs.
