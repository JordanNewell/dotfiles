#!/bin/bash
# Quick Security Audit Script
# Run this quarterly to review credentials and security settings

echo "🔐 Security Audit - $(date +%Y-%m-%d)"
echo "=========================================="
echo ""

echo "=== 🔐 Credentials ==="
echo ""
echo "Git credential helper: $(git config --global credential.helper)"
echo "Git name: $(git config --global user.name)"
echo "Git email: $(git config --global user.email)"
echo ""
echo "SSH keys:"
ls -la ~/.ssh/*.pub 2>/dev/null | awk '{print "  " $NF}' || echo "  No SSH keys found"
echo ""

echo "=== 🔍 Secrets Scan ==="
if [ -f ~/.git-credentials ]; then
  echo "⚠️  WARNING: ~/.git-credentials exists (DELETE THIS FILE)"
else
  echo "✅ No .git-credentials file found"
fi
if [ -f ~/.npmrc ] && grep -q "_auth" ~/.npmrc; then
  echo "⚠️  WARNING: Auth tokens found in ~/.npmrc"
else
  echo "✅ No auth tokens in ~/.npmrc"
fi
ENV_COUNT=$(find ~/projects -name ".env" 2>/dev/null | wc -l)
echo "Found $ENV_COUNT .env files in ~/projects"
echo ""

echo "=== 📡 Network ==="
echo "Saved WiFi networks:"
powershell.exe -Command "netsh wlan show profiles" | grep -c ":" && echo "  networks found" || echo "  None found"
echo ""

echo "=== 🖥️ System ==="
echo "Node.js: $(where node | head -1)"
echo "Volta packages: $(volta list all | wc -l) installed"
echo ""

echo "=== 🚨 Manual Checks Required ==="
echo "⬜  Run: cmdkey /list (Windows Credential Manager)"
echo "⬜  Verify 2FA: github.com/settings/security"
echo "⬜  Check email forwarding rules"
echo "⬜  Review OAuth: github.com/settings/applications"
echo "⬜  Audit browser passwords: chrome://settings/passwords"
echo "⬜  Review browser extensions"
echo "⬜  Check connected devices: myaccount.google.com/device-activity"
echo "⬜  Run Windows Update"
echo ""

echo "=========================================="
echo "Full checklist: E:/vaults/claude.code.xyz/security/quarterly-security-checklist.md"

