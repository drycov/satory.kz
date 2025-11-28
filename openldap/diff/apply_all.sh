#!/bin/bash
#
# Universal LDIF Apply Engine for Osixia/OpenLDAP
# Auto-routing between cn=config and data tree based on DN.
# Provides logs, dry-run, error reporting.
#

set -e

CONTAINER="openldap"
ADMIN_DN="cn=admin,dc=satory,dc=kz"
ADMIN_PW="admin"
LOGFILE="ldif_apply_$(date +%F_%H-%M-%S).log"
DRYRUN=0

# ----------------------------------------------------------
# Parse arguments
# ----------------------------------------------------------
while [[ "$1" != "" ]]; do
    case "$1" in
        --dry-run)
            DRYRUN=1
            ;;
        --container)
            shift
            CONTAINER="$1"
            ;;
        *)
            LDIF_FILES+=("$1")
            ;;
    esac
    shift
done

# If no explicit files → use *.ldif
if [ ${#LDIF_FILES[@]} -eq 0 ]; then
    LDIF_FILES=( *.ldif )
fi

echo "=== LDIF Apply Engine ==="
echo "Container: $CONTAINER"
echo "Files: ${LDIF_FILES[*]}"
echo "Dry-run: $DRYRUN"
echo "Log: $LOGFILE"
echo "========================="
echo ""


# ----------------------------------------------------------
# Function to determine target context from DN
# ----------------------------------------------------------
detect_context() {
    local file="$1"
    local dn
    dn=$(grep -m1 "^dn:" "$file" | sed 's/dn:[[:space:]]*//I')

    if [[ "$dn" =~ cn=config ]] || [[ "$dn" =~ olc ]]; then
        echo "config"
    else
        echo "data"
    fi
}

# ----------------------------------------------------------
# Function to apply LDIF
# ----------------------------------------------------------
apply_ldif() {
    local file="$1"
    local mode="$2"

    if [ $DRYRUN -eq 1 ]; then
        echo "[DRYRUN] Would apply $file using mode: $mode" | tee -a "$LOGFILE"
        return 0
    fi

    echo "[APPLY] $file → mode=$mode" | tee -a "$LOGFILE"

    if [ "$mode" == "config" ]; then
        # Apply to cn=config
        docker exec -i "$CONTAINER" bash -c \
            "ldapadd -Y EXTERNAL -H ldapi:/// -f /dev/stdin" \
            < "$file" 2>&1 | tee -a "$LOGFILE"

    else
        # Apply to data tree (dc=satory,dc=kz)
        docker exec -i "$CONTAINER" ldapadd -x -c \
            -D "$ADMIN_DN" -w "$ADMIN_PW" -f /dev/stdin \
            < "$file" 2>&1 | tee -a "$LOGFILE"
    fi
}

# ----------------------------------------------------------
# Main processing loop
# ----------------------------------------------------------

SUCCESS=()
FAIL=()

for file in "${LDIF_FILES[@]}"; do
    echo "-----------------------------------------------------" | tee -a "$LOGFILE"
    echo "[PROCESS] $file" | tee -a "$LOGFILE"

    if [ ! -f "$file" ]; then
        echo "[ERROR] File not found: $file" | tee -a "$LOGFILE"
        FAIL+=("$file")
        continue
    fi

    MODE=$(detect_context "$file")
    echo "[INFO] Detect: $file → mode=$MODE" | tee -a "$LOGFILE"

    if apply_ldif "$file" "$MODE"; then
        SUCCESS+=("$file")
    else
        FAIL+=("$file")
    fi

done

# ----------------------------------------------------------
# Final Report
# ----------------------------------------------------------
echo ""
echo "================= SUMMARY =================" | tee -a "$LOGFILE"

echo "SUCCESS:"
for s in "${SUCCESS[@]}"; do echo "  + $s" | tee -a "$LOGFILE"; done
echo ""

echo "FAILED:"
for f in "${FAIL[@]}"; do echo "  - $f" | tee -a "$LOGFILE"; done
echo ""

echo "Full log: $LOGFILE"
echo "==========================================="
