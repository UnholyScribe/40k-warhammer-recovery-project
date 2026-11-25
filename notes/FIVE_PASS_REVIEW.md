# Five-pass publish review

Root: `E:\40k Warhammer Recovery Project`
When: 2026-11-25T10:40:42.5561699-05:00

## Pass 1 — Inventory (what would be published)

File count: **9**

```
.gitignore
docs/CONTRIBUTING_PARAPHRASE.md
docs/IP_AND_PARAPHRASE_POLICY.md
docs/SOURCE_SCOPING.md
notes/FIVE_PASS_REVIEW.md
notes/PROGRESS.md
NOTICE.md
README.md
tools/Five-Pass-Publish-Review.ps1
```

## Pass 2 — Prose-risk patterns (GW-style wording heuristics)

No heuristic GW-prose hits in publishable text files.

## Pass 3 — Toxic / DMCA-adjacent paths excluded

OK — no game-datacards / BSData dump paths in publish set.

## Pass 4 — Required policy / attribution present

- OK `README.md`
- OK `NOTICE.md`
- OK `.gitignore`
- OK `docs/IP_AND_PARAPHRASE_POLICY.md`
- OK `docs/SOURCE_SCOPING.md`

## Pass 5 — Full read checksum + size of each text file

Each file below was opened in full for this pass (content hashed). Spot-check meaning: docs only + policy; no datasheet prose dumps.

- READ OK `.gitignore` bytes=479 sha256=eb36b6ba821c71dd3033cebf97192df40608e82f7175292d4883c261924d67a1
- READ OK `docs/CONTRIBUTING_PARAPHRASE.md` bytes=479 sha256=b0562c9d9e7d6a5be0e4c0cc493a8b937b171e519f9cd1d4ce66259177c6b6ad
- READ OK `docs/IP_AND_PARAPHRASE_POLICY.md` bytes=2190 sha256=184df39213af361bbec385caceafb7678a9e0d84d699f9b288f761a9352ffe68
- READ OK `docs/SOURCE_SCOPING.md` bytes=2392 sha256=16fb8c3beea125e970ea6e5ef3e8c509f96077ac71c7d34881218228c330f821
- READ OK `notes/FIVE_PASS_REVIEW.md` bytes=2002 sha256=2d4d23fea26262f58efde029282936dfac146fb68712438e3ea5449a38038918
- READ OK `notes/PROGRESS.md` bytes=715 sha256=1cbabb2df3f78ae07d84ee55f8773bce14f6a48aa518d88870623403849286ca
- READ OK `NOTICE.md` bytes=840 sha256=c33ef6eaff633b767139b0b2ccdea68c39ca213c074a4628160b46dfea59004c
- READ OK `README.md` bytes=1287 sha256=9be75290b4f9e5b77cd7f2fa874a6888932095504cae6ea4e9fd90ed20476eb4
- READ OK (review tool excluded from prose sniff) `tools/Five-Pass-Publish-Review.ps1` bytes=5685 sha256=920b27696dc2e0e1313c6bb2657ff05eee73b41108abcca3ea816460b5046172

## Verdict
**PASS — five passes clear for publishable set.**

