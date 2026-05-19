#!/bin/bash
# ============================================================
#  How to push this project to your GitHub repo
#  Run these commands one by one in your terminal
# ============================================================

# Step 1: Create a new folder and move into it
mkdir project-1-user-management-backup
cd project-1-user-management-backup

# Step 2: Copy your files into this folder
# (user_mgmt_backup.sh, README.md, LICENSE, .gitignore)

# Step 3: Initialize a Git repo
git init

# Step 4: Add all files
git add .

# Step 5: First commit
git commit -m "feat: add shell script for user management and backup (Project 1)"

# Step 6: Add your GitHub remote
# Replace <your-username> and <repo-name> with your actual values
git remote add origin https://github.com/BuildWithNil/Project-1-Shell-Script-for-User-Management-and-Backup-in-Linux.git

# Step 7: Push to GitHub
git branch -M main
git push -u origin main

# ✅ Done! Your project is now live on GitHub.
