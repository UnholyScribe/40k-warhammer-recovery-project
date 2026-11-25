# Source scoping (2026-11-25)

What we can pull / use for rebuild vs what we leave alone.

## Primary (mirrored locally)

| Source | URL | Use |
|---|---|---|
| **40kdc-data** | https://github.com/wn-mitch/40kdc-data | **Main line.** Stats, points, schemas, community Ability DSL / plain-English descriptions (not GW prose). NR + BattleScribe exports on `bsdata-v*` releases. Local: `mirrors\40kdc-data`, exports in `mirrors\40kdc-releases`. |
| **bsd-schema** | https://github.com/BlueWinds/bsd-schema | Format only (how `.gst` / `.cat` / NR JSON shape). Local: `mirrors\bsd-schema`. |

## Secondary (research / ingest carefully)

| Source | URL | Use |
|---|---|---|
| Official Munitorum Field Manual (web) | warhammer-community.com | **Points** and public structured facts. Prefer as numeric/source-of-truth for costs. |
| Free Core Rules PDF (Warhammer Community) | assets.warhammer-community.com | Legal free PDF for paraphrase *reference* when writing our wording. |
| Official 40k App | GW | Authoritative for current matched play; use as meaning-check, not copy-paste. |
| furka/40k-11th-list-builder | https://github.com/furka/40k-11th-list-builder | Shows MFM + Faction Pack PDF ingest patterns. Local mirror for study. |
| game-datacards/datasources | https://github.com/game-datacards/datasources | May include datasheet **prose**. Use for **structure / IDs only** until scrubbed. Do not republish prose blobs. |

## Out of scope / do not mirror here

| Source | Why |
|---|---|
| `github.com/BSData/*` (org deleted) | DMCA target; gone. |
| Public forks that are still full `wh40k-11e` dumps with book wording | Same payload GW named in the notice. |
| Scrapes whose value is “exact Codex text in JSON” | Rebuild must paraphrase. |

## Rebuild pipeline (intended)

1. **Structure + numbers** from 40kdc / MFM (and app cross-check).
2. For each ability/stratagem/enhancement: read official meaning → write **new** prose → verify identical resolution.
3. Export catalogues (NR JSON / BS `.catz`) with **our** text only.
4. Version + dataslate tag everything (`11th/YYYY-MM-DD` style).

## Gaps to fill next

- Inventory which factions/abilities in 40kdc still need paraphrase coverage vs already rewritten.
- Decide whether this folder becomes a full Watchtower station later.
- Optional: private (gitignored) authoring notes that cite page/app — never commit GW quotes.
