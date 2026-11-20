# Sprints

## Completed milestones
- PR #27: Remove retired analytics service and database integration.
- PR #28: Add read-only runtime audit and update deployment documentation.
- PR #29: Add LAN-readiness checker and setup guide.
- PR #30: Add HTTP smoke-check script and CI unit tests.

## Sprint 1 — Deployment reliability (in progress)
Goal: make existing services verifiably usable before adding apps.
- [x] HTTP smoke-check foundation (PR #30).
- [ ] Diagnose observed HTTP timeouts/disconnects on local deployment; document root causes.
- [ ] Add reliable per-service health probes, avoiding false healthy reports.
- [ ] Verify at least one full login and service workflow for each app.
Acceptance: Compose validates, CI passes, local smoke tests pass, data persists after safe recreate, and failure cases are documented.

## Sprint 2 — Operator usability (planned)
- [ ] Provide one documented, LAN-accessible entrypoint and application inventory.
- [ ] Add safe backup/restore drill and deployment preflight.
Acceptance: a new operator can configure, launch, monitor and recover the suite using documented steps.

## Sprint 3 — SMB pilot (planned)
- [ ] Define supported app bundle, onboarding checklist, security baseline and support boundaries.
- [ ] Pilot with a consenting SMB and collect measured setup effort and willingness-to-pay feedback.
Acceptance: repeatable pilot deployment and evidence-backed value proposition.
