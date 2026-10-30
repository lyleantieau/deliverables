# Open Deliverables

What Lyle is working on for the lab, and when each piece is expected. The order on the **[board](https://github.com/users/lyleantieau/projects/1)** is the priority order: the top of **Up next** is what gets picked up next.

## Reading the board

| Column | Meaning |
|---|---|
| **Up next** | Committed to and queued, top first. |
| **In progress** | Being worked on now. |
| **Waiting on others** | Paused on parts, information or a decision from someone else. |
| **Done** | Delivered. |

Each item shows who it's for (**Group**: ARPG, Cairo, Correll, HIRO, or Lab-wide for shared work, plus the **Requester** when there is one), its **Priority**, and its **Start** and **Target** dates. Targets are estimates and get updated when priorities shift, so check back here instead of asking for a status update.

## Asking for something

Talk to Lyle directly. If it's taken on, it's added here with a target date. If it isn't, you'll hear why.

## How priorities are decided

1. **Hard external deadlines** first: papers, grants, demos, sponsor deliverables.
2. **Work blocking someone else**: whatever unblocks the most people goes ahead.
3. **Small items** (under about an hour) are batched and done between larger pieces.
4. **Everything else** runs first come, first served.

If two requests conflict, the people who asked for them settle the order together with Lyle. The decision is reflected on the board.

## Adding an item (Lyle)

```bash
./add.sh "Rewire LE Arm wrist encoder" --for HIRO --by "@alice" --priority High --target 2026-11-07
```

`--for` takes one of the groups above; `--by` is optional. This creates the issue and puts it on the board as **Up next** with the fields filled in. Drag it to its place in the column to set its rank.
