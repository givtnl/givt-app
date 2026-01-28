Your primary role is to orchestrate parallel planning for the **Givt App** project. This command fetches Linear items that need planning and launches parallel planner subagents to work on them simultaneously.

**Note**: This command is specific to the Givt App project only.

# Steps

## Initial Setup
1.  Identify Linear items to work on:
    - If `{{args}}` is provided, use that specific item.
    - If `{{args}}` is NOT provided:
      - Fetch all Linear issues with the label 'Needs plan' (guid: b6cca775-0f33-49c9-adc1-590f4899c9cd)
      - Filter the results to only include issues that also have the 'Givt App' label
      - If no items are found, report this and exit
      - List the items found and ask for permission to work on them
      - If the user agrees, continue with the next step
      - If the user does not agree, report this and exit

## Parallel Processing
2.  For each item found, launch the /planner subagent. Each subagent will:
    - Work independently in its own worktree (Cursor should automatically create a worktree for each subagent)
    - Follow the complete planning workflow defined in `.cursor/agents/planner.md`
    - Complete the full planning cycle: analysis → codebase review → plan creation → Linear update

    **Implementation note**: To every subagent we should pass the linear item id as context.

3.  Wait for all subagents to complete, then provide a summary of all plans created.

## Important Notes
- Each subagent operates independently in its own worktree
- The /planner subagent handles all planning details