import type { VercelRequest, VercelResponse } from '@vercel/node';

interface PlantData {
  nickname: string;
  species: string;
  vibe: string;
  status: string;
  healthStreak: number;
  lastWatered?: string; // ISO date string
}

interface WeatherData {
  current: {
    temperature: number;
    humidity: number;
    precipitation: number;
  };
}

interface RequestBody {
  plant: PlantData;
  weatherData?: WeatherData;
  systemPrompt: string;
}

interface GeminiRequest {
  contents: Array<{
    parts: Array<{
      text: string;
    }>;
  }>;
  generationConfig?: {
    temperature: number;
  };
}

interface GeminiResponse {
  candidates: Array<{
    content: {
      parts: Array<{
        text: string;
      }>;
    };
  }>;
  error?: {
    message: string;
    code: number;
  };
}

export default async function handler(
  req: VercelRequest,
  res: VercelResponse
) {
  // Handle CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    // Get API key from environment variable
    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) {
      console.error('GEMINI_API_KEY environment variable is not set');
      return res.status(500).json({ 
        error: 'Server configuration error. Please contact support.' 
      });
    }

    // Validate request body
    const body: RequestBody = req.body;
    if (!body || !body.plant || !body.systemPrompt) {
      return res.status(400).json({ 
        error: 'Missing required fields: plant and systemPrompt are required' 
      });
    }

    const { plant, weatherData, systemPrompt } = body;

    // Build user prompt
    let userPrompt = `Generate a message from ${plant.nickname}, a ${plant.species} with a ${plant.vibe} vibe.`;
    
    if (weatherData) {
      userPrompt += ` Current weather: ${weatherData.current.temperature}°C, ${weatherData.current.humidity}% humidity, ${weatherData.current.precipitation}mm precipitation.`;
    }
    
    userPrompt += ` Plant status: ${plant.status}. Health streak: ${plant.healthStreak} days.`;
    
    if (plant.lastWatered) {
      const lastWateredDate = new Date(plant.lastWatered);
      const now = new Date();
      const daysSince = Math.floor((now.getTime() - lastWateredDate.getTime()) / (1000 * 60 * 60 * 24));
      userPrompt += ` Last watered: ${daysSince} days ago.`;
    }

    // Combine system prompt with user prompt
    const fullPrompt = `${systemPrompt}\n\n${userPrompt}`;

    // Prepare Gemini API request
    const geminiRequest: GeminiRequest = {
      contents: [
        {
          parts: [
            {
              text: fullPrompt
            }
          ]
        }
      ],
      generationConfig: {
        temperature: 0.8
      }
    };

    // Make request to Gemini API
    const model = 'gemini-2.5-flash-lite';
    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${encodeURIComponent(apiKey)}`;
    
    const geminiResponse = await fetch(geminiUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(geminiRequest),
    });

    const geminiData: GeminiResponse = await geminiResponse.json();

    // Handle Gemini API errors
    if (!geminiResponse.ok || geminiData.error) {
      const errorMessage = geminiData.error?.message || `API request failed with status ${geminiResponse.status}`;
      console.error('Gemini API Error:', errorMessage);
      
      return res.status(geminiResponse.status || 500).json({
        error: errorMessage
      });
    }

    // Extract message from response
    const message = geminiData.candidates?.[0]?.content?.parts?.[0]?.text || "I'm doing great! 🌿";

    // Return success response
    return res.status(200).json({
      message: message
    });

  } catch (error) {
    console.error('Error generating message:', error);
    return res.status(500).json({
      error: error instanceof Error ? error.message : 'Internal server error'
    });
  }
}

