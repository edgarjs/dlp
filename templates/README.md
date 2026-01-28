# Templates

Ready-to-use templates for DLP output artifacts. Copy and adapt these templates when creating documentation for your project.

---

## Quick Reference: Phase to Template Mapping

| Phase        | Artifact                   | Template                                                       |
| ------------ | -------------------------- | -------------------------------------------------------------- |
| REQUIREMENTS | Requirements specification | [requirements-specification.md](requirements-specification.md) |
| REQUIREMENTS | User stories               | [user-stories.md](user-stories.md)                             |
| DESIGN       | Design decisions           | [design-decision.md](design-decision.md)                       |
| DESIGN       | Architecture documentation | [architecture.md](architecture.md)                             |
| DESIGN       | Data model definitions     | [data-model.md](data-model.md)                                 |
| DESIGN       | API specification          | [api-contract.yml](api-contract.yml)                           |

---

## When to Create Each Artifact

### REQUIREMENTS Phase

| Template                        | Create When                                       |
| ------------------------------- | ------------------------------------------------- |
| `requirements-specification.md` | Always — the primary output of requirements work  |
| `user-stories.md`               | When capturing requirements from user perspective |

### DESIGN Phase

| Template             | Create When                                          |
| -------------------- | ---------------------------------------------------- |
| `design-decision.md` | For each significant design choice with alternatives |
| `architecture.md`    | For new systems or major architectural changes       |
| `data-model.md`      | When defining data structures and relationships      |
| `api-contract.yml`   | When the system exposes APIs (REST, GraphQL, etc.)   |

---

## Usage Instructions

### Step 1: Copy the Template

Copy the relevant template to your project's documentation directory:

```
project/
├── docs/                          ← Your documentation directory
│   ├── requirements.md            ← Copied from templates/requirements-specification.md
│   ├── architecture.md            ← Copied from templates/architecture.md
│   └── decisions/                 ← Design decisions
│       └── 001-database-choice.md ← Copied from templates/design-decision.md
```

### Step 2: Replace Placeholders

Templates contain placeholders in `[brackets]` and `TODO` markers:

- `[Project Name]` → Replace with your project name
- `[Description]` → Replace with actual description
- `TODO: ...` → Complete the indicated section

### Step 3: Adapt to Your Needs

Templates are starting points. Modify them as needed:

- Remove sections that don't apply
- Add sections your project requires
- Adjust formatting to match project conventions

---

## Template Formats

### Markdown Templates (.md)

Most templates use Markdown for maximum compatibility:

- Human-readable
- Version control friendly
- Renders in most tools

### OpenAPI Template (.yml)

The API contract template uses OpenAPI 3.1 YAML format:

- Industry-standard API specification
- Machine-readable for code generation
- Supported by many tools (Swagger, Postman, etc.)

---

## Creating New Templates

If you need an artifact type not covered by existing templates:

1. Follow the structure of existing templates
2. Include clear section headers
3. Use placeholders consistently (`[brackets]` for required, `TODO` for notes)
4. Add a brief description at the top explaining the template's purpose

---

## Template Quality Checklist

Good templates:

- [ ] Have a clear purpose stated at the top
- [ ] Use consistent placeholder format
- [ ] Include all necessary sections
- [ ] Omit unnecessary sections
- [ ] Are easy to fill in
- [ ] Produce useful documentation when completed
