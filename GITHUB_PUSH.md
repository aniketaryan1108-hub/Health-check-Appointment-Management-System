# Push Project to GitHub — Repo Name: **Aniket**

Git is installed and your project is committed locally. Follow these steps to push to GitHub.

---

## Step 1 — Create repository on GitHub

1. Open: **https://github.com/new**
2. **Repository name:** `Aniket`
3. **Description (optional):** Health Check Appointment Management System
4. Choose **Public** or **Private**
5. **Do NOT** check "Add a README" (you already have one)
6. Click **Create repository**

---

## Step 2 — Push from your PC

Open **Git Bash** or **PowerShell** in your project folder and run:

```bash
cd "c:\Users\DELL\OneDrive\Desktop\Java Module2\HealthCheckAppointmentManagmentSystem"

git remote add origin https://github.com/YOUR_GITHUB_USERNAME/Aniket.git

git push -u origin main
```

Replace `YOUR_GITHUB_USERNAME` with your real GitHub username (e.g. if your profile is `github.com/aniket123`, use `aniket123`).

---

## Or use the batch script

Double-click **`push-to-github.bat`** in the project folder. It will ask for your GitHub username and push to `Aniket`.

---

## Login when prompted

- **Username:** your GitHub username  
- **Password:** use a **Personal Access Token** (not your GitHub password)  
  - Create token: GitHub → Settings → Developer settings → Personal access tokens → Generate new token  
  - Enable scope: `repo`

---

## What is uploaded

- All Java servlets and JSP pages  
- CSS, JavaScript, database SQL  
- README and documentation  
- **Not uploaded:** `db.properties` (password file — use `db.properties.example` instead)

---

## Your repo URL after push

```
https://github.com/YOUR_GITHUB_USERNAME/Aniket
```
