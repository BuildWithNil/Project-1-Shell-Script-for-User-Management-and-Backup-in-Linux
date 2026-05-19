#!/bin/bash
# ============================================================
#  Shell Script for User Management and Backup in Linux
#  Project 1 - DevOps Zero to Hero | Build with Nil
#  GitHub: https://github.com/BuildWithNil/Project-1-Shell-Script-for-User-Management-and-Backup-in-Linux
# ============================================================

set -euo pipefail

# ── Colors ──────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Logging helpers ──────────────────────────────────────────
log_info()    { echo -e "${CYAN}[INFO]${RESET}  $*"; }
log_success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
log_error()   { echo -e "${RED}[ERROR]${RESET} $*" >&2; }

# ── Root check ───────────────────────────────────────────────
require_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This operation requires root privileges. Run with sudo."
        exit 1
    fi
}

# ============================================================
#  USER MANAGEMENT
# ============================================================

# Add a new user
add_user() {
    require_root
    read -rp "Enter username to add: " username
    if id "$username" &>/dev/null; then
        log_warn "User '$username' already exists."
        return
    fi
    read -rp "Enter full name (comment): " fullname
    read -rsp "Enter password: " password
    echo

    useradd -m -c "$fullname" "$username"
    echo "$username:$password" | chpasswd
    log_success "User '$username' created successfully."
}

# Delete an existing user
delete_user() {
    require_root
    read -rp "Enter username to delete: " username
    if ! id "$username" &>/dev/null; then
        log_error "User '$username' does not exist."
        return
    fi
    read -rp "Also remove home directory? [y/N]: " remove_home
    if [[ "$remove_home" =~ ^[Yy]$ ]]; then
        userdel -r "$username"
    else
        userdel "$username"
    fi
    log_success "User '$username' deleted."
}

# Modify user account
modify_user() {
    require_root
    read -rp "Enter username to modify: " username
    if ! id "$username" &>/dev/null; then
        log_error "User '$username' does not exist."
        return
    fi

    echo -e "\n  ${BOLD}Modify options:${RESET}"
    echo "  1) Change password"
    echo "  2) Change full name (comment)"
    echo "  3) Lock account"
    echo "  4) Unlock account"
    echo "  5) Change login shell"
    read -rp "  Choice: " mod_choice

    case $mod_choice in
        1)
            read -rsp "New password: " new_pass; echo
            echo "$username:$new_pass" | chpasswd
            log_success "Password updated for '$username'."
            ;;
        2)
            read -rp "New full name: " new_name
            usermod -c "$new_name" "$username"
            log_success "Full name updated for '$username'."
            ;;
        3)
            usermod -L "$username"
            log_success "Account '$username' locked."
            ;;
        4)
            usermod -U "$username"
            log_success "Account '$username' unlocked."
            ;;
        5)
            read -rp "New shell (e.g. /bin/bash): " new_shell
            usermod -s "$new_shell" "$username"
            log_success "Shell changed to '$new_shell' for '$username'."
            ;;
        *)
            log_warn "Invalid choice."
            ;;
    esac
}

# List all non-system users
list_users() {
    echo -e "\n${BOLD}${CYAN}=== User Accounts ===${RESET}"
    awk -F: '$3 >= 1000 && $1 != "nobody" {printf "  %-20s UID=%-6s Shell=%s\n", $1, $3, $7}' /etc/passwd
}

# ============================================================
#  GROUP MANAGEMENT
# ============================================================

create_group() {
    require_root
    read -rp "Enter group name to create: " grpname
    if getent group "$grpname" &>/dev/null; then
        log_warn "Group '$grpname' already exists."
        return
    fi
    groupadd "$grpname"
    log_success "Group '$grpname' created."
}

delete_group() {
    require_root
    read -rp "Enter group name to delete: " grpname
    if ! getent group "$grpname" &>/dev/null; then
        log_error "Group '$grpname' does not exist."
        return
    fi
    groupdel "$grpname"
    log_success "Group '$grpname' deleted."
}

add_user_to_group() {
    require_root
    read -rp "Enter username: " username
    read -rp "Enter group name: " grpname
    if ! id "$username" &>/dev/null; then
        log_error "User '$username' does not exist."
        return
    fi
    if ! getent group "$grpname" &>/dev/null; then
        log_error "Group '$grpname' does not exist."
        return
    fi
    usermod -aG "$grpname" "$username"
    log_success "User '$username' added to group '$grpname'."
}

list_groups() {
    echo -e "\n${BOLD}${CYAN}=== Groups ===${RESET}"
    getent group | awk -F: '$3 >= 1000 {printf "  %-20s GID=%-6s Members=%s\n", $1, $3, $4}' 
    echo ""
}

# ============================================================
#  BACKUP FEATURE
# ============================================================

backup_directory() {
    read -rp "Enter full path of directory to back up: " src_dir
    if [[ ! -d "$src_dir" ]]; then
        log_error "Directory '$src_dir' does not exist."
        return
    fi

    read -rp "Enter backup destination directory [default: /tmp/backups]: " dest_dir
    dest_dir="${dest_dir:-/tmp/backups}"
    mkdir -p "$dest_dir"

    local timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")
    local dir_name
    dir_name=$(basename "$src_dir")
    local archive="${dest_dir}/${dir_name}_backup_${timestamp}.tar.gz"

    log_info "Creating compressed archive..."
    tar -czf "$archive" -C "$(dirname "$src_dir")" "$dir_name"

    local size
    size=$(du -sh "$archive" | cut -f1)
    log_success "Backup created: $archive  (Size: $size)"
}

# ============================================================
#  MENUS
# ============================================================

user_menu() {
    while true; do
        echo -e "\n${BOLD}${CYAN}╔══════════════════════════╗"
        echo -e "║    USER MANAGEMENT       ║"
        echo -e "╚══════════════════════════╝${RESET}"
        echo "  1) Add user"
        echo "  2) Delete user"
        echo "  3) Modify user"
        echo "  4) List users"
        echo "  0) Back to main menu"
        read -rp "  → Choice: " choice
        case $choice in
            1) add_user ;;
            2) delete_user ;;
            3) modify_user ;;
            4) list_users ;;
            0) return ;;
            *) log_warn "Invalid option." ;;
        esac
    done
}

group_menu() {
    while true; do
        echo -e "\n${BOLD}${CYAN}╔══════════════════════════╗"
        echo -e "║    GROUP MANAGEMENT      ║"
        echo -e "╚══════════════════════════╝${RESET}"
        echo "  1) Create group"
        echo "  2) Delete group"
        echo "  3) Add user to group"
        echo "  4) List groups"
        echo "  0) Back to main menu"
        read -rp "  → Choice: " choice
        case $choice in
            1) create_group ;;
            2) delete_group ;;
            3) add_user_to_group ;;
            4) list_groups ;;
            0) return ;;
            *) log_warn "Invalid option." ;;
        esac
    done
}

main_menu() {
    while true; do
        echo -e "\n${BOLD}${GREEN}"
        echo "  ╔══════════════════════════════════════════╗"
        echo "  ║   DevOps Project 1 — Build with Nil      ║"
        echo "  ║   User Management & Backup Script        ║"
        echo "  ╚══════════════════════════════════════════╝"
        echo -e "${RESET}"
        echo "  1) User Management"
        echo "  2) Group Management"
        echo "  3) Backup a Directory"
        echo "  4) List Users"
        echo "  5) List Groups"
        echo "  0) Exit"
        echo ""
        read -rp "  → Select option: " opt
        case $opt in
            1) user_menu ;;
            2) group_menu ;;
            3) backup_directory ;;
            4) list_users ;;
            5) list_groups ;;
            0) echo -e "\n${GREEN}Goodbye!${RESET}\n"; exit 0 ;;
            *) log_warn "Invalid option. Please try again." ;;
        esac
    done
}

# ── Entry point ──────────────────────────────────────────────
main_menu
