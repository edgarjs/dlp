# Security

Security protects systems and data from unauthorized access, modification, or destruction. It is not a feature to add later—it must be considered at every phase.

---

## Security Mindset

### Assume Breach

Design systems assuming attackers will get in. Limit damage through:

- Defense in depth (multiple layers)
- Least privilege (minimal access)
- Segmentation (contain breaches)

### Trust Boundaries

Identify where trust changes:

- User input (never trusted)
- External APIs (verify responses)
- Internal services (depends on architecture)
- Database (trusted but protect access)

Data crossing trust boundaries must be validated.

---

## Common Vulnerabilities

### Injection

Untrusted data sent to an interpreter as part of a command or query.

**SQL Injection**

Vulnerable:

```
query = "SELECT * FROM users WHERE id = " + user_input
// user_input = "1; DROP TABLE users"
```

Safe:

```
query = "SELECT * FROM users WHERE id = ?"
execute(query, [user_input])  // Parameterized query
```

**Command Injection**

Vulnerable:

```
system("ping " + user_input)
// user_input = "127.0.0.1; rm -rf /"
```

Safe:

```
Use libraries that don't invoke shells
Validate input against allowlist
```

**Prevention:**

- Use parameterized queries/prepared statements
- Avoid dynamic command construction
- Validate and sanitize all input

### Cross-Site Scripting (XSS)

Malicious scripts injected into web pages viewed by other users.

Vulnerable:

```
<div>Welcome, ${username}</div>
// username = "<script>steal_cookies()</script>"
```

Safe:

```
<div>Welcome, ${escape_html(username)}</div>
```

**Prevention:**

- Escape output based on context (HTML, JavaScript, URL, CSS)
- Use templating engines with auto-escaping
- Implement Content Security Policy (CSP)

### Broken Authentication

Weaknesses in authentication mechanisms.

**Common issues:**

- Weak password requirements
- Missing brute-force protection
- Insecure session management
- Credentials in URLs or logs

**Prevention:**

- Enforce strong passwords
- Implement rate limiting and account lockout
- Use secure session tokens (random, sufficient length)
- Never log credentials or tokens

### Broken Access Control

Users accessing resources or actions beyond their permissions.

Vulnerable:

```
// User changes URL from /orders/123 to /orders/456
// Server returns order 456 without checking ownership
```

Safe:

```
order = get_order(order_id)
if order.user_id != current_user.id:
    return error("Forbidden")
```

**Prevention:**

- Check authorization on every request
- Deny by default
- Use indirect references (not sequential IDs)
- Log access control failures

### Security Misconfiguration

Insecure default configurations, incomplete setup, or exposed information.

**Common issues:**

- Default credentials unchanged
- Unnecessary features enabled
- Detailed error messages exposed
- Missing security headers

**Prevention:**

- Harden configurations
- Disable unused features
- Use generic error messages externally
- Implement security headers

### Sensitive Data Exposure

Inadequate protection of sensitive information.

**Prevention:**

- Encrypt data at rest and in transit
- Use strong, current algorithms
- Don't store sensitive data unnecessarily
- Mask or truncate in logs and displays

---

## Secure Coding Practices

### Input Validation

Validate all input at system boundaries.

Validation checklist:

- [ ] Type (string, number, date)
- [ ] Length (min, max)
- [ ] Format (regex, structure)
- [ ] Range (allowed values)
- [ ] Business rules

**Allowlist over denylist:**

Poor:

```
reject if input contains "<script>"  // Easily bypassed
```

Better:

```
accept only if input matches [a-zA-Z0-9_]+
```

### Output Encoding

Encode output based on context to prevent injection.

| Context        | Encoding             |
| -------------- | -------------------- |
| HTML body      | HTML entity encoding |
| HTML attribute | Attribute encoding   |
| JavaScript     | JavaScript encoding  |
| URL parameter  | URL encoding         |
| CSS            | CSS encoding         |

### Authentication

**Password storage:**

- Never store plaintext passwords
- Use adaptive hashing (bcrypt, Argon2)
- Use unique salt per password

**Session management:**

- Generate random session IDs (sufficient entropy)
- Regenerate session ID on login
- Expire sessions appropriately
- Invalidate on logout

**Multi-factor authentication:**

- Implement for sensitive operations
- Support standard protocols (TOTP)

### Authorization

**Principles:**

- Least privilege (grant minimum necessary)
- Deny by default
- Check on every request
- Fail securely (deny on error)

**Implementation:**

Check authorization:

1. Authenticate user (who are they?)
2. Load permissions (what can they do?)
3. Check specific permission for action
4. Deny if not explicitly permitted

### Cryptography

**Do:**

- Use established libraries
- Use current algorithms (AES-256, SHA-256+, RSA-2048+)
- Use authenticated encryption (GCM mode)
- Generate keys securely

**Don't:**

- Invent your own cryptography
- Use deprecated algorithms (MD5, SHA1, DES)
- Hardcode keys or secrets
- Use predictable IVs or nonces

### Secrets Management

**Never:**

- Commit secrets to version control
- Hardcode secrets in code
- Log secrets
- Pass secrets in URLs

**Do:**

- Use environment variables or secret managers
- Rotate secrets regularly
- Audit secret access
- Use different secrets per environment

---

## Security by Phase

### Requirements Phase

- Identify sensitive data and operations
- Define authentication requirements
- Define authorization model
- Consider compliance requirements (GDPR, PCI, HIPAA)
- Document security requirements explicitly

### Design Phase

- Identify trust boundaries
- Design authentication and authorization
- Plan encryption strategy
- Consider threat model
- Review third-party dependencies for security posture

### Development Phase

- Follow secure coding practices
- Use security linters and static analysis
- Review code for security issues
- Keep dependencies updated
- Handle errors without exposing details

### Testing Phase

- Include security test cases
- Test authentication bypass attempts
- Test authorization at every endpoint
- Test input validation with malicious input
- Consider penetration testing for critical systems

---

## Security Review Checklist

### Authentication

- [ ] Strong password policy enforced
- [ ] Brute-force protection implemented
- [ ] Secure session management
- [ ] Logout invalidates session
- [ ] Password reset is secure

### Authorization

- [ ] Access control on all endpoints
- [ ] Deny by default
- [ ] No direct object references without checks
- [ ] Admin functions protected
- [ ] Authorization failures logged

### Input/Output

- [ ] All input validated
- [ ] Output encoded for context
- [ ] Parameterized queries used
- [ ] File uploads validated and sandboxed
- [ ] No sensitive data in URLs

### Data Protection

- [ ] Sensitive data encrypted at rest
- [ ] TLS for data in transit
- [ ] Secrets not in code or logs
- [ ] Minimal data collection
- [ ] Secure data deletion when needed

### Configuration

- [ ] Default credentials changed
- [ ] Unnecessary features disabled
- [ ] Security headers implemented
- [ ] Error messages don't leak info
- [ ] Dependencies up to date

---

## Responding to Security Issues

### When You Find a Vulnerability

1. **Assess severity** — What data or access is at risk?
2. **Contain** — Can you limit exposure quickly?
3. **Fix** — Develop and test a fix
4. **Deploy** — Push fix to production
5. **Review** — How did this happen? How to prevent similar issues?

### Severity Assessment

| Severity | Description                                    | Response            |
| -------- | ---------------------------------------------- | ------------------- |
| Critical | Remote code execution, data breach imminent    | Immediate fix       |
| High     | Authentication bypass, sensitive data exposure | Fix within days     |
| Medium   | Limited impact vulnerability                   | Fix in next release |
| Low      | Minor issue, requires unlikely conditions      | Backlog             |

---

## Resources

For deeper coverage, consult:

- OWASP Top 10 (web application risks)
- OWASP Cheat Sheet Series (specific guidance)
- CWE (Common Weakness Enumeration)
- Language/framework-specific security guides
