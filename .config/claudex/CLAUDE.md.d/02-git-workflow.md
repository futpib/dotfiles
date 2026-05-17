# Git Workflow Best Practices

- Never commit unless explicitly asked to
- Never push unless explicitly asked to
- Use descriptive branch names that indicate the purpose of the changes
- If Claude made changes to code, it may include co-authorship
- Commit message guidelines:
  - Describe the changes being made, focusing on the "why" rather than the "what"
  - Keep first line concise (50-72 characters)
  - Add detailed explanation in subsequent paragraphs if needed
  - Write for a reader unfamiliar with the conversation. Don't reference
    rejected alternatives only discussed in chat (e.g. "instead of doing X"),
    forward-looking promises ("will follow in a separate commit"), or other
    session-only context. The message must stand alone in `git log`.
  - `#123` in commit messages or any GitHub text field refers to issue/PR numbers — avoid it unless you intend to link an issue or PR