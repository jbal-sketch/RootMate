# Vercel API Setup Guide

This guide will help you set up the RootMate API functions on Vercel.

## Prerequisites

1. **Node.js installed** (check with `node --version`)
2. **Vercel CLI installed** (check with `vercel --version`)

## Step 1: Install Dependencies

First, make sure all required packages are installed:

```bash
npm install
```

This will install:
- `@vercel/node` - For serverless functions
- `typescript` - For TypeScript support
- `@types/node` - TypeScript types for Node.js

## Step 2: Set Up Environment Variable

You need a Google Gemini API key. Get one from: https://aistudio.google.com/app/apikey

### For Local Development:

```bash
# Set environment variable for local dev
vercel env add GEMINI_API_KEY
# When prompted, select "Development" and paste your API key
```

### For Production:

1. Go to [Vercel Dashboard](https://vercel.com/dashboard)
2. Select your RootMate project
3. Go to **Settings** → **Environment Variables**
4. Add:
   - **Name:** `GEMINI_API_KEY`
   - **Value:** Your Gemini API key
   - **Environment:** Production, Preview, Development (select all)

## Step 3: Test Locally

Start the Vercel dev server:

```bash
vercel dev
```

This will:
- Start the server on `http://localhost:3000` (for local development only)
- Serve your marketing site from `/marketing`
- Serve API functions from `/api/*`

### Test the API:

```bash
# Test production API
   curl -X POST https://root-mate.vercel.app/api/generate-message \
  -H "Content-Type: application/json" \
  -d '{
    "plant": {
      "nickname": "Test",
      "species": "Fiddle Leaf Fig",
      "vibe": "Drama Queen",
      "status": "Thirsty",
      "healthStreak": 5,
      "lastWatered": "2024-01-15T10:00:00Z"
    },
    "systemPrompt": "You are a test plant."
  }'
```

Or use the test harness:

```bash
python3 test_harness.py
```

## Step 4: Deploy to Production

### Option A: Automatic (via Git)

If your project is connected to GitHub:
1. Push your changes to the main branch
2. Vercel will automatically deploy

### Option B: Manual Deploy

```bash
vercel --prod
```

## Troubleshooting

### API returns 404

- Make sure `vercel.json` includes the API rewrite rule
- Check that `api/generate-message.ts` exists
- Restart `vercel dev` after making changes

### API returns 500 (Server Error)

- Check that `GEMINI_API_KEY` is set correctly
- Check Vercel logs: `vercel logs`
- Verify your Gemini API key is valid

### TypeScript Errors

- Make sure `tsconfig.json` exists
- Run `npm install` to ensure TypeScript is installed
- Check that `@vercel/node` is in dependencies

## Project Structure

```
RootMate/
├── api/
│   └── generate-message.ts    # API endpoint
├── marketing/                  # Marketing site (served as static)
├── vercel.json                # Vercel configuration
├── tsconfig.json              # TypeScript config
└── package.json               # Dependencies
```

## How It Works

1. **Marketing Site**: Served from `/marketing` directory as static files
2. **API Functions**: Files in `/api` become serverless functions
   - `/api/generate-message.ts` → `https://your-domain.com/api/generate-message`
3. **Routing**: `vercel.json` handles routing between static files and API functions

## Next Steps

Once everything is working:
1. Test with the test harness: `python3 test_harness.py`
2. The iOS app's `APIConfiguration.swift` is already configured to use the production URL
3. Test from your iOS app

