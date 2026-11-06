#!/bin/sh

# DSM keeps pkgindexer_add / pkgindexer_del in /usr/syno/bin, which is not on
# the PATH used by the installer scripts. Add it so index registration works.
PATH="/usr/syno/bin:/usr/syno/sbin:${PATH}"
export PATH

PACKAGE_ROOT="${SYNOPKG_PKGDEST}"
UI_DIR="${PACKAGE_ROOT}/app"

register_indexes() {
    pkgindexer_add "${UI_DIR}/index.conf"
    pkgindexer_add "${UI_DIR}/helptoc.conf"
}

unregister_indexes() {
    pkgindexer_del "${UI_DIR}/helptoc.conf"
    pkgindexer_del "${UI_DIR}/index.conf"
}

fix_permissions() {
    chmod 0755 "${UI_DIR}/scripts/api.cgi"
    chmod 0755 "${PACKAGE_ROOT}/bin/tank-dom-rr-manager-lib.sh" "${PACKAGE_ROOT}/bin/tank-dom-rr-manager-job.sh"
    chmod 0755 "${PACKAGE_ROOT}/var"
}

cleanup_legacy_ui() {
    rm -f "${UI_DIR}/index.cgi" "${UI_DIR}/api.cgi"
    rm -rf "${PACKAGE_ROOT}/ui"
}

# DSM 7 relocates the package var/ folder out of target/, so the generic
# installer's chown never touches these files. The CGI runs as EFF_USER and
# needs to read the private HMAC config; the early /tmp error log may still be
# owned by a user from a previous install.
fix_var_ownership() {
    conf="/var/packages/${SYNOPKG_PKGNAME}/var/update-source.conf"
    [ -f "${conf}" ] || conf="${PACKAGE_ROOT}/var/update-source.conf"
    if [ -f "${conf}" ]; then
        chown "${EFF_USER}" "${conf}" 2>/dev/null || true
        chmod 0600 "${conf}" 2>/dev/null || true
    fi
    errlog="/tmp/tank-dom-rr-manager-api-error.log"
    if [ -f "${errlog}" ]; then
        chown "${EFF_USER}" "${errlog}" 2>/dev/null || true
    fi
}

service_postinst() {
    mkdir -p "${PACKAGE_ROOT}/var"
    cleanup_legacy_ui
    fix_permissions
    fix_var_ownership
    register_indexes
}

service_postupgrade() {
    mkdir -p "${PACKAGE_ROOT}/var"
    cleanup_legacy_ui
    fix_permissions
    fix_var_ownership
    register_indexes
}

service_postuninst() {
    unregister_indexes
}
