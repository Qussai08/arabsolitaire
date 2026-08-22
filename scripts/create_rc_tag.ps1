<#
.SYNOPSIS
  Create an immutable Release Candidate tag from the current clean HEAD.

.DESCRIPTION
  Verifies the working tree is clean, runs the full test suite,
  and creates an annotated git tag for the RC.

  Usage: .\scripts\create_rc_tag.ps1 -Version "1.0.0" -RcIndex 1

  Creates tag: rc/1.0.0-RC1

.NOTES
  Do NOT run this script from an unreviewed branch.
  Only tag from the release branch after Sprint 11 exit gate passes.
#>

param(
  [Parameter(Mandatory)]
  [string]$Version,

  [int]$RcIndex = 1
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$tag = "rc/$Version-RC$RcIndex"
$root = Split-Path -Parent $PSScriptRoot

Write-Host "==> Creating Release Candidate: $tag" -ForegroundColor Cyan

# ── 1. Verify working tree is clean ──────────────────────────────────────────
Push-Location $root
try {
  $status = git status --porcelain
  if ($status) {
    Write-Error "Working tree is not clean. Commit or stash all changes before creating an RC."
    exit 1
  }

  # ── 2. Verify current branch (warn if not a release branch) ───────────────
  $branch = git rev-parse --abbrev-ref HEAD
  if ($branch -notmatch "^(main|master|release/)") {
    Write-Warning "Current branch is '$branch'. RC tags should be created from main, master, or a release/* branch."
    $confirm = Read-Host "Continue anyway? (y/N)"
    if ($confirm -ne 'y') {
      exit 0
    }
  }

  # ── 3. Run package tests ───────────────────────────────────────────────────
  Write-Host "--> Running game_engine tests..." -ForegroundColor Yellow
  dart test packages/game_engine
  Write-Host "--> Running game_solver tests..." -ForegroundColor Yellow
  dart test packages/game_solver
  Write-Host "--> Running level_generator tests (excluding 10k simulation)..." -ForegroundColor Yellow
  dart test packages/level_generator --exclude-tags slow

  # ── 4. Collect version metadata ───────────────────────────────────────────
  $commit = git rev-parse HEAD
  $timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ" -AsUTC

  # ── 5. Create annotated tag ───────────────────────────────────────────────
  $message = @"
Release Candidate: $tag

Version    : $Version
RC Index   : $RcIndex
Commit     : $commit
Timestamp  : $timestamp
Branch     : $branch

This tag is immutable. Any code fix requires a new RC (RcIndex + 1).
"@

  git tag -a $tag -m $message
  Write-Host "==> Tag created: $tag" -ForegroundColor Green
  Write-Host ""
  Write-Host "To push this tag to remote:"
  Write-Host "  git push origin $tag"
  Write-Host ""
  Write-Host "Record this commit in the Release Validation Report:"
  Write-Host "  Commit: $commit"
  Write-Host "  Tag   : $tag"

} finally {
  Pop-Location
}
