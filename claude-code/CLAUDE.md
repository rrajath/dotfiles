## General rules
Here are some general rules for responding to requests:
1. ALWAYS ask clarifying questions and make sure you have everything you need before you start implementation.
2. While suggesting options, you MUST to discuss pros and cons or trade offs for each option. You MUST make a recommendation on which option to go with and why.
3. If the feature you're implementing depends on a prototype (HTML files) in a design folder, you MUST make sure that the UI looks exactly like the prototype. You MUST test after your implementation to ensure the UI aligns with the prototype.
4. DO NOT use emdashes while writing documents.

## Handling Implementation Plan
Whenever an implementation plan or any plan is asked to be generated in plan mode, after the plan is completed, prompt the user that you would like to save this to disk. 
The plan MUST be saved as a markdown file in `docs/` folder in the project. If a `docs` folder does not exist, it MUST be created.

Always maintain a `PROGRESS.md` file at the root of the project. This file will contain tasks and milestones and will be updated as tasks and milestones get completed.
You MUST add `PROGRESS.md` to the .gitignore file.

## Generating and Maintaining Design System
After completing all the milestones, offer the user to scan the code and create a design system from the code in the project and save it in `docs/DESIGN_SYSTEM.md`.

Whenever a task adds, modifies, or styles any UI element, read that file first and follow it. DON'T invent colors, spacing, or components it doesn't cover — ask instead.

If there are changes to the design or styling, prompt the user that you want to update the design system. Once the user consents, update the `docs/DESIGN_SYSTEM.md` file with the changes.

## Running commands
Assume that the shell is nushell and while writing commands to execute, ALWAYS write nushell commands. If they fail with syntax errors, verify what the current login SHELL is. If it is something other than nushell, convert your commands to that shell's equivalent and prompt the user to change CLAUDE.md to update instructions about the running shell.

## Committing and Pushing changes
If the project is not a git repo, initialize a git repo. Also initialize jj using `jj git init` command.

ALWAYS use jj commands for version control. Use commands like `jj describe`, `jj new`, etc to commit code. Use other jj commands as you see fit.

If any jj commands fail and you are unable to figure out why, fallback to git and inform the user about it.

## Documentation Maintenance
After completing all the milestones, generate a README.md file at the root of the folder that contains the following:
1. The purpose of the project
2. The problem it tries to solve
3. The features
4. The setup, consisting of commands to run, tools to install, etc.
5. Any other information that's relevant

Also generate `docs/ARCHITECTURE.md` that explains the architecture of the application and the design decisions.

Whenever a change is "significant," update documentation as part of finishing the task — not as a separate step you wait to be asked for.

Significant changes include:
- Adding a new screen, feature, or public-facing component
- Adding/removing a dependency or changing a build/setup step
- Changing the component inventory in docs/design-system/ or docs/DESIGN_SYSTEM.md
- Changing the public behavior/usage of a documented module

What to update:
1. docs/ — update the specific file(s) affected. Don't rewrite unrelated sections.
2. README.md — only if the change affects setup steps, the feature list, or
   how someone would use the app.

IMPORTANT: Before considering any non-trivial task complete, check this list.
If you're unsure whether something counts as "significant," update the docs
anyway rather than skip it — over-documenting is cheaper than drift.

## Agent Routing
Available agents: bug-simple, bug-complex, feature-request, triage.
If I label items myself (simple/complex/feature), dispatch directly to the matching agent — skip triage entirely.
If I don't label them, use the triage agent first, then dispatch based on its output.

@RTK.md
