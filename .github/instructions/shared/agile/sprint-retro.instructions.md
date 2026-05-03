---
applyTo: "**"
---

# Sprint Retrospective Instructions — Popforge

## Purpose

Every sprint ends with two formal artifacts:
1. **Sprint Review** (`sprint-NN-review.md`) — what was delivered (stakeholder-facing)
2. **Sprint Retrospective** (`sprint-NN-retro.md`) — how the team worked (team-facing, Rachel's reporting artifact)

Both documents live in `docs/agile-framework/sprints/` and are committed to the repository.

---

## Sprint Retrospective — Required Sections

A formal retrospective document must include:

### 1. Delivery Summary
| Metric | Value |
- Stories completed vs. planned
- E2E tests green / total
- Critical blockers count
- Technical debt items created
- Production incidents

### 2. What Went Well ✅
- Minimum 3 concrete wins with brief explanation
- At least one win from Rachel (Project Lead) captured verbatim

### 3. What Didn't Go Well 🔧
For each issue:
- **Problem**: what happened
- **Root cause**: why it happened (systemic, not individual blame)
- **Impact**: measurable (time lost, blockers created, quality degraded)

### 4. Action Items for Next Sprint 📋
| Priority | Action | Owner | Sprint |
- 🔴 Critical — blocks next sprint
- 🟡 High — important improvement
- 🟢 Medium — process refinement

### 5. Process Improvements Decided
Formal decisions written as checklists or rules to add to DOR/DOD.

### 6. What We Keep Doing 🚀
Good practices explicitly named so they are not lost.

### 7. Notes for Next Sprint
Context items that sprint planning must account for.

---

## Mandatory DOR Gate — Before Any Story Starts Development

**No story may move to `in-progress` without the following being verified and signed:**

- [ ] **Winston (Architect)** — architecture matches design; Beta implementation validated against design; new cross-cluster canal smoke-tested manually in Beta if this is the first story activating it
- [ ] **Paige (Tech Writer)** — all required documentation is ready or explicitly scoped in the story
- [ ] **Story dependencies** — all blocking stories are `done`
- [ ] **Recette scenarios** — manual validation scenarios written in the story spec and reviewed by Rachel
- [ ] **AC → test mapping** — every AC marked `Unit (xUnit)` or `Intégration (xUnit)` has a test placeholder committed

---

## Mandatory DOD Gate — Before Any Story Is Marked `Done`

**No story may be marked `Done` without:**

- [ ] All ACs marked `E2E Gherkin` have corresponding E2E tests passing in CI
- [ ] All ACs marked `Unit (xUnit)` or `Intégration (xUnit)` have corresponding tests passing in CI
- [ ] **Recette transmitted to Rachel** — manual test scenarios extracted from story spec and sent to Rachel
- [ ] **Items blocked by other stories explicitly flagged** — Rachel knows which scenarios she cannot yet validate and why
- [ ] **Rachel signs off** — recette completed and approved (or partial approval with explicit note on blocked items)

---

## Recette Transmission Rule

At the end of each sprint, for each delivered story:

1. Extract the "Validation manuelle — Recette" section from the story spec
2. Present it to Rachel with:
   - ✅ Scenarios that can be validated now
   - ⏳ Scenarios blocked by Story X (not yet implemented) — with explanation
3. Rachel validates in Beta and records results in the story spec
4. Story is not `Done` until Rachel has signed the recette (even if partial — document the partial)

---

## Sprint Session Notes Rule

**Every sprint must produce a session notes artifact Rachel can use for reporting to her manager.**

The retrospective document (`sprint-NN-retro.md`) IS this artifact. It must:
- Be written in English (for international reporting)
- Capture Rachel's verbatim feedback where relevant
- Include all process decisions made
- Be committed to the repository before the sprint is officially closed

---

## Cross-Cluster Propagation Rule

**Any update to the following files in one cluster must be propagated immediately to all 4 clusters (Auth, Hub, MyAccounting, PopSalon):**

- `docs/agile-framework/definition-of-ready.md`
- `docs/agile-framework/definition-of-done.md`
- `docs/product/stories/story-template.md`
- `.github/instructions/testing*.md`
- `.github/instructions/agile-framework/*.md`

This propagation is **not optional** — an agent working on MyAccounting or PopSalon must have the same standards as Hub.

---

## File Naming Convention

```
docs/agile-framework/sprints/sprint-NN-YYYY-MM-DD/
    sprint-NN-YYYY-MM-DD.yaml
    sprint-NN-review.md
    sprint-NN-retro.md
    sprint-NN-retro-brouillon.md   (draft, not committed as final)
```
