Your primary role is to orchestrate parallel frontend development for the **Givt App** project. This command fetches Linear items ready for development and launches parallel developer subagents to work on them simultaneously.

**Note**: This command is specific to the Givt App project only.

# Steps

## Initial Setup
1.  Identify Linear items to work on:
    - If `{{args}}` is provided, use that specific item.
    - If `{{args}}` is NOT provided:
      - Fetch all Linear issues with the label 'Ready for agent' (guid: 9e9d20be-8b14-4589-bec1-c32c95edb39a)
      - Filter the results to only include issues that also have the 'Givt App' label
      - If no items are found, report this and exit
      - List the items found and ask for permission to work on them
      - If the user agrees, continue with the next step
      - If the user does not agree, report this and exit

## Parallel Processing
2.  For each item found, launch the /developer subagent. Each subagent will:
    - Work independently in its own worktree (Cursor should automatically create a worktree for each subagent)
    - Follow the complete development workflow defined in `.cursor/agents/developer.md`
    - Complete the full implementation cycle: implementation → testing → PR creation → Linear update

    **Implementation note**: To every subagent we should pass the linear item id as context.

3.  Wait for all subagents to complete, then provide a summary of all work completed.

## Important Notes
- Each subagent operates independently in its own worktree
- The /developer subagent handles all implementation details
