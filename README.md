# skills

Portable agent skills in the open [Agent Skills](https://agentskills.io) format (`SKILL.md` + scripts + references).
They work in any agent that supports the format: **Codex, Claude Code, Antigravity, OpenCode, Devin** and others.

| Skill | What it does |
|---|---|
| [`open-pr`](open-pr/SKILL.md) | Opens a pull request with real screenshots or a short recording of the changed screens (Android emulator, iOS simulator, web). Verifies every capture, previews the body with GitHub's renderer, asks for confirmation, then runs `gh pr create --attach`. |
| [`open-pr-setup`](open-pr-setup/SKILL.md) | Inspects a repository and writes the project profile `.agents/open-pr.md` that `open-pr` reads: base branch, PR format, verify commands, build and capture commands, pitfalls. |

## Install

```bash
git clone https://github.com/jiunshinn/skills.git
./skills/install.sh <your-repo>     # one project
./skills/install.sh --global        # all projects for your user
```

The script copies each skill to `.agents/skills/<name>/` and links `.claude/skills/<name>` to it.
It never overwrites a folder that it did not install.

Or use the [skills CLI](https://github.com/vercel-labs/skills): `npx skills add jiunshinn/skills`.

### Where each agent looks

| Agent | Project | User (global) |
|---|---|---|
| Codex | `.agents/skills/` | `~/.agents/skills/` |
| Antigravity | `.agents/skills/` (old: `.agent/skills/`) | see your version's docs (`~/.gemini/antigravity…/skills/`) |
| OpenCode | `.opencode/skills/`, `.agents/skills/`, `.claude/skills/` | `~/.config/opencode/skills/` and compatible folders |
| Devin | `.agents/skills/` (committed to the repo) | — (Devin CLI: `~/.config/cognition/skills/`) |
| Claude Code | `.claude/skills/` | `~/.claude/skills/` |

`install.sh` covers every row's project path with two folders. For a global path that the script does not cover, copy or link the skill folder there by hand.

**Devin** runs in the cloud and reads skills from the repository. Install into the project and commit `.agents/skills/` and `.agents/open-pr.md`.

## Use

1. In the target repository, ask your agent: "set up open-pr for this repo". The setup skill writes `.agents/open-pr.md`. All agents share this one profile.
2. Review the profile. Commit it if the team shares it.
3. On a feature branch, ask: "open a PR" (in Codex you can also type `$open-pr`). The agent captures the changed screens, shows the draft, and waits for your confirmation before it pushes.

## Requirements

- `gh` 2.99.0 or later (for `--attach`), authenticated
- Node.js 18.3 or later
- An agent that can view images, to verify captures (if it cannot, you check the captures yourself)
- Per platform: Android SDK (`adb`), Xcode on macOS (`xcrun simctl`), or Playwright for web. Cloud agents such as Devin usually cannot run the iOS simulator.
- `ffmpeg` to check video frames

## License

MIT
