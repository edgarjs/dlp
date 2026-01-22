# Contributing to Development Lifecycle Protocol (DLP)

Thank you for helping improve the Development Lifecycle Protocol! This document outlines how to submit changes, bug reports, and improvements.

## Before You Start

- Read [`foundations/principles.md`](./foundations/principles.md) to understand the protocol's core values
- Ensure your contribution aligns with the protocol's scope (see [README.md](./README.md) for what is and isn't covered)

## Contribution Types

### Bug Fixes & Corrections

- **Found an error?** Open an issue describing the problem
- **Have a fix?** Submit a PR with a clear description of what's wrong and why your fix works
- Reference the specific file and line number: `file_path:line_number`

### Improvements & Clarifications

- Improve clarity or add examples to existing sections
- Fix formatting or structure issues
- Reorganize content for better readability
- Add cross-references between related sections

### New Guidance

For new checklists, decision trees, or phases:

1. **Open an issue first** — Describe what's missing and why it belongs in the protocol
2. **Wait for discussion** — Get feedback before writing
3. **Follow the structure** — Match the format of existing documents in the same directory
4. **Reference existing content** — Link to relevant principles, terminology, and patterns

## Submission Process

### 1. Fork & Create a Branch

```bash
git clone git@github.com:your-username/dlp.git
cd dlp
git checkout -b your-feature-branch
```

Use descriptive branch names: `fix/typo-in-requirements`, `improve/clarify-artifact-precedence`, `add/new-phase-guidance`

### 2. Make Your Changes

- **Edit existing files** to fix errors or improve clarity
- **Create new files** only if adding a new section (coordinate in an issue first)
- **Maintain formatting** — Use consistent Markdown style with the existing docs
- **Preserve line breaks** — Keep line length reasonable (~80-100 chars where practical)

### 3. Follow Protocol Conventions

- **Use checklists** for procedural guidance (see `requirements/` for examples)
- **Use decision trees** for branching logic (see `design/` for examples)
- **Use Mermaid diagrams** for visual workflows
- **No executable code** — Use pseudocode or plain language instead
- **Link cross-references** — Connect to related sections using relative paths

### 4. Test Your Contribution

- [ ] Does it align with `foundations/principles.md`?
- [ ] Are all links valid and using relative paths?
- [ ] Is the Markdown rendering correctly?
- [ ] Does it avoid duplication with existing content?

### 5. Submit a Pull Request

Include in your PR description:

```markdown
## Summary

Brief explanation of what this PR changes and why.

## Type of Change

- [ ] Bug fix
- [ ] Improvement/clarification
- [ ] New guidance
- [ ] Documentation

## Related Issue

Fixes #(issue number) or closes #(issue number)

## Testing

Describe how you verified this change doesn't break anything.

## Checklist

- [ ] I've read CONTRIBUTING.md
- [ ] Changes follow the protocol's conventions
- [ ] Links are relative paths and work correctly
- [ ] No executable code (pseudocode/examples only)
```

## Review Process

Your PR will be reviewed for:

1. **Alignment with protocol values** — Does it fit the philosophy?
2. **Clarity & completeness** — Is it understandable?
3. **Consistency** — Does it match existing patterns?
4. **Scope** — Does it belong in this protocol?

Maintainers may request changes. Respond to feedback promptly and feel free to ask questions.

## Code of Conduct

- Be respectful and constructive
- Assume good faith in others
- Focus on ideas, not individuals
- Help others learn and improve

## Questions?

- Open an issue and tag it as `question`
- Check existing issues and discussions first
- Reference the specific section of the protocol you're asking about

---

Thank you for contributing! 🙏
