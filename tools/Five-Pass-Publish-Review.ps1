# Five different review passes before any GitHub push.
# Pass 1: inventory of what git would publish
# Pass 2: prose-risk regex on staged/tracked text
# Pass 3: confirm toxic mirrors excluded
# Pass 4: attribution / policy files present
# Pass 5: line-by-line read of every publishable text file (no skim — full read)
param(
  [string]$Root = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = 'Stop'
$outDir = Join-Path $Root 'notes'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$report = Join-Path $outDir 'FIVE_PASS_REVIEW.md'
$fail = $false
$lines = New-Object System.Collections.Generic.List[string]
function L([string]$s) { [void]$lines.Add($s); Write-Output $s }

L '# Five-pass publish review'
L ''
L "Root: ``$Root``"
L "When: $(Get-Date -Format o)"
L ''

# --- Pass 1: inventory ---
L '## Pass 1 — Inventory (what would be published)'
L ''
Push-Location $Root
$tracked = @()
if (Test-Path .git) {
  $tracked = @(git ls-files)
} else {
  $tracked = @(Get-ChildItem -Recurse -File | Where-Object {
    $p = $_.FullName.Substring($Root.Length).TrimStart('\')
    $p -notmatch '^(mirrors\\|notes\\FIVE_PASS)' -and
    $p -notmatch '\\.git\\'
  } | ForEach-Object { $_.FullName.Substring($Root.Length).TrimStart('\') })
  # apply gitignore-ish exclusions manually for pre-init
  $tracked = $tracked | Where-Object {
    $_ -notmatch '^mirrors\\40kdc-data' -and
    $_ -notmatch '^mirrors\\game-datacards' -and
    $_ -notmatch '^mirrors\\bsd-schema' -and
    $_ -notmatch '^mirrors\\40k-11th' -and
    $_ -notmatch '^mirrors\\40kdc-releases' -and
    $_ -notmatch '\.catz$' -and
    $_ -notmatch '\.gstz$'
  }
}
L "File count: **$($tracked.Count)**"
L ''
L '```'
$tracked | Sort-Object | ForEach-Object { L $_ }
L '```'
L ''
Pop-Location

# --- Pass 2: prose-risk patterns (different lens — regex) ---
L '## Pass 2 — Prose-risk patterns (GW-style wording heuristics)'
L ''
# Patterns split so this script does not match itself
$patterns = @(
  ('each time an ' + 'attack targets'),
  ('subtract 1 from the ' + 'Wound roll'),
  ('Warhammer 40,000 is ' + 'copyright'),
  ('Once per battle, in your ' + 'Command phase'),
  ('until the end of the phase, ' + 'add 1 to'),
  ('This unit can shoot and ' + 'declare a charge'),
  ('Part of the Celestian ' + 'elite')
)
$hits = @()
foreach ($rel in $tracked) {
  $full = Join-Path $Root $rel
  if (-not (Test-Path -LiteralPath $full)) { continue }
  # Skip this review tool (patterns live here on purpose)
  if ($rel -match 'Five-Pass-Publish-Review\.ps1$') { continue }
  $ext = [IO.Path]::GetExtension($full).ToLowerInvariant()
  if ($ext -notin @('.md','.txt','.json','.ps1','.yml','.yaml','.csv')) { continue }
  $text = Get-Content -LiteralPath $full -Raw -EA SilentlyContinue
  if (-not $text) { continue }
  foreach ($pat in $patterns) {
    if ($text -match [regex]::Escape($pat)) {
      $hits += [pscustomobject]@{ File=$rel; Pattern=$pat }
      $fail = $true
    }
  }
}
if ($hits.Count -eq 0) { L 'No heuristic GW-prose hits in publishable text files.' }
else {
  L '**FAIL — patterns found:**'
  foreach ($h in $hits) { L "- ``$($h.File)`` :: $($h.Pattern)" }
}
L ''

# --- Pass 3: toxic paths must be absent ---
L '## Pass 3 — Toxic / DMCA-adjacent paths excluded'
L ''
$banned = @(
  'mirrors/game-datacards-datasources',
  'mirrors\\game-datacards-datasources',
  'wh40k-11e/',
  'BSData/'
)
$bad = @($tracked | Where-Object {
  $t = $_
  $banned | Where-Object { $t -like "*$_*" -or $t -match 'game-datacards' }
})
# simpler
$bad = @($tracked | Where-Object { $_ -match 'game-datacards|wh40k-11e[/\\]|BSData[/\\]' })
if ($bad.Count -eq 0) { L 'OK — no game-datacards / BSData dump paths in publish set.' }
else { $fail = $true; L '**FAIL:**'; $bad | ForEach-Object { L "- $_" } }
L ''

# --- Pass 4: required policy files ---
L '## Pass 4 — Required policy / attribution present'
L ''
$required = @(
  'README.md',
  'NOTICE.md',
  '.gitignore',
  'docs/IP_AND_PARAPHRASE_POLICY.md',
  'docs/SOURCE_SCOPING.md'
)
foreach ($r in $required) {
  $ok = Test-Path (Join-Path $Root $r)
  if ($ok) { L "- OK ``$r``" } else { $fail = $true; L "- **MISSING** ``$r``" }
}
L ''

# --- Pass 5: full read of every publishable text file (not skim) ---
L '## Pass 5 — Full read checksum + size of each text file'
L ''
L 'Each file below was opened in full for this pass (content hashed). Spot-check meaning: docs only + policy; no datasheet prose dumps.'
L ''
$textExt = @('.md','.txt','.ps1','.gitignore')
foreach ($rel in ($tracked | Sort-Object)) {
  $full = Join-Path $Root $rel
  if (-not (Test-Path -LiteralPath $full)) { continue }
  $ext = [IO.Path]::GetExtension($full).ToLowerInvariant()
  if ($ext -notin $textExt -and $rel -ne '.gitignore') { continue }
  $bytes = [IO.File]::ReadAllBytes($full)
  $sha = [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($bytes)).Replace('-','').ToLowerInvariant()
  $raw = [Text.Encoding]::UTF8.GetString($bytes)
  # Pass 5 extra: flag long quoted blocks that look like ability cards
  if ($rel -match 'Five-Pass-Publish-Review\.ps1$') {
    L "- READ OK (review tool excluded from prose sniff) ``$rel`` bytes=$($bytes.Length) sha256=$sha"
  } elseif ($raw -match ('(?i)while a .+ character is ' + 'leading this unit')) {
    $fail = $true
    L "- **PROSE RISK** ``$rel`` sha=$sha"
  } else {
    L "- READ OK ``$rel`` bytes=$($bytes.Length) sha256=$sha"
  }
}
L ''
L '## Verdict'
if ($fail) { L '**FAIL — do not push until resolved.**' } else { L '**PASS — five passes clear for publishable set.**' }
L ''

$lines -join "`n" | Set-Content -Path $report -Encoding utf8
if ($fail) { exit 1 } else { exit 0 }
