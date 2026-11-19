# skills

Agent skills for [Claude Code](https://docs.claude.com/en/docs/claude-code/skills).

| Skill | What it does |
|---|---|
| [`open-pr`](open-pr/SKILL.md) | Opens a pull request with real screenshots or a short recording of the changed screens (Android emulator, iOS simulator, web). Verifies every capture, previews the body with GitHub's renderer, asks for confirmation, then runs `gh pr create --attach`. |
| [`open-pr-setup`](open-pr-setup/SKILL.md) | Inspects a repository and writes the project profile `.claude/open-pr.md` that `open-pr` reads: base branch, PR format, verify commands, build and capture commands, pitfalls. |

## Install

Copy the skill folders into your project or your user skills folder:

```bash
git clone https://github.com/jiunshinn/skills.git
cp -R skills/open-pr skills/open-pr-setup <your-repo>/.claude/skills/   # one project
# or
cp -R skills/open-pr skills/open-pr-setup ~/.claude/skills/            # all projects
```

## Use

1. In the target repository, ask Claude: "set up open-pr for this repo". The setup skill writes `.claude/open-pr.md`.
2. Review the profile. Commit it if the team shares it.
3. On a feature branch, ask: "open a PR". Claude captures the changed screens, shows the draft, and waits for your confirmation before it pushes.

## Requirements

- `gh` 2.99.0 or later (for `--attach`), authenticated
- Node.js 18.3 or later
- Per platform: Android SDK (`adb`), Xcode (`xcrun simctl`), or Playwright for web
- `ffmpeg` to check video frames

## License

MIT
