# ADR-0001 — Data access hidden behind repository interfaces

**Status:** accepted · 2026-10-16 · decided by @OsamaKhalifa

## Decision

All data access goes through one repository interface per feature (e.g. `HoldingsRepository`). Features, notifiers and domain logic depend only on the interface. v1 has one implementation: local SQLite (via Drift). A server-backed implementation can replace it later without touching feature code.

## Why

Product owner requirement: v1 is device-only, but a later phase may move storage to a server. The swap must be one new implementation + one provider override, not a rewrite.

This is the one approved exception to the "no interface with a single implementation" rule. The second caller is known and planned, not speculative.

## Rules that make the swap real

- Interface methods are **async** (`Future` / `Stream`) even though SQLite is local. A server is never synchronous.
- Interfaces speak **domain types** only. No Drift row classes, no SQL, no table names leak out.
- IDs are **UUID strings**, generated on the client. No auto-increment integers — they do not survive a move to a server.
- Each record carries `createdAt` / `updatedAt` (UTC). Enough for a future sync; no sync logic now.
- The implementation is chosen in exactly one place: the Riverpod provider for that repository.
- The SQLite file lives only in the app sandbox (`path_provider` application-support dir), never in the project folder. Tests use an in-memory database.
- Domain errors (`NotFound`, `Conflict`, `StorageUnavailable`) are defined next to the interface. Implementations map their own exceptions to these.

## What we do NOT build now

- No generic `Repository<T>` base class. One interface per feature, shaped by what that feature needs.
- No sync engine, no offline queue, no conflict resolution, no remote implementation.
- No "unit of work" or query DSL.

## Rejected alternatives

- **Features call Drift directly** — fastest today, but the server move becomes a rewrite of every feature.
- **Generic CRUD repository** — fits nothing well; real features need specific queries (e.g. "holdings held for a full hawl").

## Trigger to revisit

A server-side phase is approved, or a feature needs a transaction across two repositories.
