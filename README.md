# 🐧 Project 1 — Shell Script for User Management and Backup in Linux

> [Build with Nil](https://github.com/BuildWithNil/Project-1-Shell-Script-for-User-Management-and-Backup-in-Linux)

---

## 📌 Overview

This project is a Bash shell script that automates **user management** and **directory backup** tasks on a Linux system. It provides a clean, interactive command-line interface to manage users and groups without memorizing individual Linux commands, and creates compressed, timestamped backups of any directory.

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| Linux (Ubuntu / Fedora / any distro) | Operating system |
| Bash Shell | Scripting language |
| Git & GitHub | Version control & repository |
| Vim / Nano / VS Code | Text editor |

---

## 📁 Project Structure

```
project-1-user-management-backup/
├── user_mgmt_backup.sh     # Main shell script
└── README.md               # Project documentation
```

---

## ⚙️ Features

### 👤 User Management
- ➕ Add a new user (with home directory and password)
- ❌ Delete an existing user (optionally remove home directory)
- ✏️ Modify a user — change password, full name, shell, lock/unlock account
- 📋 List all non-system users

### 👥 Group Management
- ➕ Create a new group
- ❌ Delete a group
- ➕ Add a user to an existing group
- 📋 List all groups

### 💾 Backup
- 📦 Compress and archive any specified directory using `tar -czf`
- 🕐 Auto-generates timestamped archive filenames (`dirname_backup_YYYYMMDD_HHMMSS.tar.gz`)
- 📂 Configurable destination directory (default: `/tmp/backups`)

---

## 🚀 Getting Started

### Prerequisites

- A Linux system (Ubuntu, Fedora, CentOS, etc.)
- `bash` (pre-installed on all Linux systems)
- `sudo` / root access for user and group operations

### 1. Clone the Repository

```bash
git clone https://github.com/BuildWithNil/Project-1-Shell-Script-for-User-Management-and-Backup-in-Linux.git
cd Project-1-Shell-Script-for-User-Management-and-Backup-in-Linux
```

### 2. Make the Script Executable

```bash
chmod +x user_mgmt_backup.sh
```

### 3. Run the Script

```bash
sudo bash user_mgmt_backup.sh
```

---

## 🖥️ Usage Demo

```
  ╔══════════════════════════════════════════╗
  ║   DevOps Project 1 — Build with Nil      ║
  ║   User Management & Backup Script        ║
  ╚══════════════════════════════════════════╝

  1) User Management
  2) Group Management
  3) Backup a Directory
  4) List Users
  5) List Groups
  0) Exit

  → Select option: 3

Enter full path of directory to back up: /home/alice/projects
Enter backup destination directory [default: /tmp/backups]:
[INFO]  Creating compressed archive...
[OK]    Backup created: /tmp/backups/projects_backup_20240519_143022.tar.gz  (Size: 4.2M)
```

---

## 📋 Requirements

### Functional Requirements
- [x] Add, delete, and modify Linux user accounts
- [x] Create and manage user groups
- [x] Backup (compress + archive) a specified directory
- [x] User-friendly interactive CLI with clear options

### Non-Functional Requirements
- [x] **Performance** — executes tasks swiftly using native Linux commands
- [x] **Security** — root privilege guard on all sensitive operations; `set -euo pipefail` for strict error handling
- [x] **Portability** — pure Bash, runs on any Linux distribution without modification

---

## 🔐 Security Notes

- The script enforces root access for all user/group operations using a `require_root()` check.
- Passwords are set via `chpasswd` (not passed as plain-text arguments in commands).
- `set -euo pipefail` ensures the script exits immediately on any unexpected error.

---

## 📄 Resume Description

**Objective:** Created a Linux shell script to automate user management and directory backups.

**Key Achievements:**
- Automated user account and group management tasks, improving efficiency and accuracy.
- Developed an automated backup system with timestamped archives, enhancing data security and integrity.
- Gained expertise in Linux system administration, shell scripting, and version control with Git/GitHub.

**Impact:** Streamlined system administration tasks, reinforced Linux security practices, and ensured reliable backup processes.

---

## 📚 Reference

- **GitHub (Course Repo):** [ShellScripting-For-DevOps](https://github.com/BuildWithNil/Project-1-Shell-Script-for-User-Management-and-Backup-in-Linux.git)

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to change.

---

## 📝 License

This project is open-source and available under the [MIT License](LICENSE).
