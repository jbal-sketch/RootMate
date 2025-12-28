# RootMate Backend API

This directory contains serverless functions for the RootMate backend API.

## Environment Variables

Set the following environment variable in your Vercel project settings:

- `GEMINI_API_KEY`: Your Google Gemini API key (get one from https://aistudio.google.com/app/apikey)

## API Endpoints

### POST `/api/generate-message`

Generates an AI-powered message from a plant using Google Gemini API.

#### Request Body

```json
{
  "plant": {
    "nickname": "Fiona",
    "species": "Fiddle Leaf Fig",
    "vibe": "dramaQueen",
    "status": "thirsty",
    "healthStreak": 5,
    "lastWatered": "2024-01-15T10:00:00Z" // Optional ISO date string
  },
  "weatherData": { // Optional
    "current": {
      "temperature": 15.5,
      "humidity": 75,
      "precipitation": 2.5
    }
  },
  "systemPrompt": "You are a Fiddle Leaf Fig with a Drama Queen personality..."
}
```

#### Response

**Success (200):**
```json
{
  "message": "OMG bestie, it's literally POURING outside and I'm still THIRSTY?? 😤💀"
}
```

**Error (400/500):**
```json
{
  "error": "Error message here"
}
```

## Local Development

1. Install Vercel CLI:
   ```bash
   npm install -g vercel
   ```

2. Set environment variable:
   ```bash
   vercel env add GEMINI_API_KEY
   ```

3. Run locally:
   ```bash
   vercel dev
   ```

4. Test the endpoint:
   ```bash
   curl -X POST https://rootmate.vercel.app/api/generate-message \
     -H "Content-Type: application/json" \
     -d '{"plant": {...}, "systemPrompt": "..."}'
   ```

## Deployment

The API is automatically deployed when you push to your main branch (if connected to Vercel). Make sure to set the `GEMINI_API_KEY` environment variable in the Vercel dashboard.

## Security

- API key is stored securely in Vercel environment variables
- CORS is configured to allow requests from iOS app
- Input validation is performed on all requests
- Error messages don't expose sensitive information

## Rate Limiting

Consider implementing rate limiting in production to control costs:
- Per-user/device rate limits
- Daily/monthly quotas
- Monitor usage through Vercel logs

