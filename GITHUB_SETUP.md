# GitHub Setup Instructions

Your local Git repository is initialized and ready! Follow these steps to push to GitHub:

## Step 1: Create the Repository on GitHub

1. Go to [GitHub.com](https://github.com) and sign in
2. Click the "+" icon in the top right, then select "New repository"
3. Repository name: `RootMate`
4. Description: "iOS gardening companion app"
5. Choose **Public** or **Private** (your choice)
6. **DO NOT** initialize with README, .gitignore, or license (we already have these)
7. Click "Create repository"

## Step 2: Push Your Code

You have two options for authentication:

### Option A: Using HTTPS with Personal Access Token (Recommended)

1. Generate a Personal Access Token:
   - Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Click "Generate new token (classic)"
   - Give it a name like "RootMate Development"
   - Select scopes: `repo` (full control of private repositories)
   - Click "Generate token"
   - **Copy the token immediately** (you won't see it again!)

2. Push your code:
   ```bash
   git push -u origin main
   ```
   - When prompted for username: enter `jbal-sketch`
   - When prompted for password: paste your Personal Access Token (not your GitHub password)

### Option B: Using SSH (More Secure)

1. Check if you have an SSH key:
   ```bash
   ls -la ~/.ssh
   ```

2. If you don't have one, generate it:
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
   (Press Enter to accept default location, optionally set a passphrase)

3. Add your SSH key to GitHub:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
   Copy the output, then:
   - Go to GitHub → Settings → SSH and GPG keys
   - Click "New SSH key"
   - Paste your public key and save

4. Update the remote URL to use SSH:
   ```bash
   git remote set-url origin git@github.com:jbal-sketch/RootMate.git
   ```

5. Push your code:
   ```bash
   git push -u origin main
   ```

## Step 3: Verify

After pushing, visit: https://github.com/jbal-sketch/RootMate

You should see all your files there!

## Future Commits

Once set up, you can use standard Git workflow:

```bash
# Make changes to files
git add .
git commit -m "Your commit message"
git push
```

## Troubleshooting

- **"Repository not found"**: Make sure you created the repository on GitHub first
- **"Authentication failed"**: Double-check your username and token/SSH key
- **"Permission denied"**: Ensure your SSH key is added to your GitHub account

