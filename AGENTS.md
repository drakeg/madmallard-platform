# Agent instructions — Mad Mallard Platform

Follow [central repository standards](https://github.com/drakeg/madmallard-repository-standards) where compatible with this project. Scope all actions to this repository. Preserve all persistent volumes, secrets, databases, and user data. Never run `docker compose down -v`.

Read README, SPRINTS, BACKLOG, RELEASES, CONTRIBUTING, SECURITY and Compose before changing code. Work Build → Deploy → Test → Fix → Redeploy → Continue. Use reviewable PRs and verify checks; never claim unrun tests passed. Fix broken deployments and CI before adding nonessential features.

Maintain Shields.io badges directly below README H1. Inspect Compose, workflows and license before adding badges; dynamic status badges must never be hardcoded green. Update badges with stack changes and check badge URLs during CI where feasible.

Keep local Docker Compose data persistent. Default services to loopback unless LAN exposure is explicitly configured with firewall and application URL settings. Maintain sprint plans and backlog with acceptance criteria, document releases under SemVer, and never commit credentials.

Commercial goal: make an SMB-ready, supportable business-app deployment with minimal administration and a credible paid onboarding/support offering. Do not claim validated customer demand.
