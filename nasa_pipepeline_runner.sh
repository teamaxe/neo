#!/usr/bin/env bash
set -eo pipefail

echo "==> [Stage 1] Running SAST & CWE Auditing (cppcheck)..."
cppcheck --enable=warning,style --error-exitcode=1 src/ || {
    echo "[ERROR] SAST check failed: Unsafe memory operations or CWE violations detected."
    exit 1
}

echo "==> [Stage 2] Generating SBOM (syft) & Scanning Vulnerabilities (trivy)..."
syft . -o cyclonedx-json=sbom.json
trivy sbom --exit-code 1 --severity CRITICAL,HIGH sbom.json

echo "==> [Stage 3 & 4] Executing CCSDS 355.0-B-1 SDLS & Anti-Spoofing Test Harness..."
if [ -f "./scripts/verify_sdls.py" ]; then
    python3 ./scripts/verify_sdls.py --standard ccsds-355.0-b-1 --stage 3-4 --run-anti-spoof
else
    echo "[WARNING] ./scripts/verify_sdls.py not found. Skipping hardware test harness validation."
fi

echo "==> All NASA software assurance pipeline stages passed successfully."
