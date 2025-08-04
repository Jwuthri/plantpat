const { GoogleGenerativeAI } = require('@google/generative-ai');

class AIService {
  constructor() {
    this.genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
  }

  async identifyPlant(imageData, imageType = 'image/jpeg') {
    console.log('🧠 [AI-SERVICE] Starting plant identification...', {
      imageType,
      dataLength: imageData.length,
      timestamp: new Date().toISOString()
    });
    
    try {
      console.log('🧠 [AI-SERVICE] Initializing Gemini 2.5 Flash model...');
      const model = this.genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

      const prompt = `
        Analyze this plant image and provide detailed identification information.
        
        Please respond in JSON format with the following structure:
        {
          "plantIdentification": {
            "species": "Common name of the plant",
            "scientificName": "Scientific name",
            "commonNames": ["alternative common names"],
            "confidence": 0.95,
            "alternativeMatches": [
              {
                "species": "Alternative species name",
                "scientificName": "Alt scientific name",
                "confidence": 0.85
              }
            ]
          },
          "careInstructions": {
            "watering": {
              "frequency": "weekly",
              "amount": "moderate",
              "notes": "Water when top inch of soil is dry"
            },
            "lighting": {
              "type": "bright indirect",
              "notes": "Avoid direct sunlight"
            },
            "humidity": {
              "level": "moderate",
              "notes": "50-60% humidity ideal"
            },
            "temperature": {
              "min": 18,
              "max": 24,
              "notes": "Avoid cold drafts"
            },
            "fertilizing": {
              "frequency": "monthly",
              "type": "balanced liquid fertilizer",
              "notes": "Dilute to half strength"
            },
            "repotting": {
              "frequency": "every 2-3 years",
              "season": "spring",
              "notes": "Use well-draining potting mix"
            }
          },
          "suggestedReminders": [
            {
              "type": "watering",
              "title": "Water Plant",
              "description": "Check soil moisture and water if needed",
              "frequency": "weekly",
              "daysInterval": 7,
              "recurring": true,
              "priority": "high"
            },
            {
              "type": "fertilizing",
              "title": "Fertilize Plant",
              "description": "Apply diluted liquid fertilizer",
              "frequency": "monthly", 
              "daysInterval": 30,
              "recurring": true,
              "priority": "medium"
            },
            {
              "type": "inspection",
              "title": "Health Check",
              "description": "Inspect for pests, diseases, and overall health",
              "frequency": "weekly",
              "daysInterval": 7,
              "recurring": true,
              "priority": "medium"
            }
          ]
        }
      `;

      const imagePart = {
        inlineData: {
          data: imageData,
          mimeType: imageType
        }
      };

      console.log('🧠 [AI-SERVICE] 🚀 Calling Gemini API...');
      const startTime = Date.now();
      
      const result = await model.generateContent([prompt, imagePart]);
      const response = await result.response;
      const text = response.text();
      
      const aiCallTime = Date.now() - startTime;
      console.log('🧠 [AI-SERVICE] ✅ Gemini API response received', {
        responseTime: `${aiCallTime}ms`,
        responseLength: text.length
      });

      // Parse JSON from response
      console.log('🧠 [AI-SERVICE] 🔍 Parsing JSON response...');
      const jsonMatch = text.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        const parsedResult = JSON.parse(jsonMatch[0]);
        console.log('🧠 [AI-SERVICE] ✅ Plant identification complete!', {
          species: parsedResult.plantIdentification?.species,
          confidence: parsedResult.plantIdentification?.confidence,
          totalTime: `${Date.now() - startTime}ms`
        });
        return parsedResult;
      }

      console.error('🧠 [AI-SERVICE] ❌ Could not parse AI response as JSON. Raw response:', text.substring(0, 200));
      throw new Error('Could not parse AI response as JSON');
    } catch (error) {
      console.error('🧠 [AI-SERVICE] ❌ Plant identification error:', error.message);
      throw error;
    }
  }

  async diagnosePlantHealth(imageData, imageType = 'image/jpeg', plantContext = null) {
    console.log('🧠 [AI-SERVICE] Starting plant health diagnosis...', {
      imageType,
      dataLength: imageData.length,
      hasContext: !!plantContext,
      timestamp: new Date().toISOString()
    });
    
    try {
      console.log('🧠 [AI-SERVICE] Initializing Gemini 2.5 Flash model...');
      const model = this.genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

      const contextInfo = plantContext 
        ? `\nPlant context: ${plantContext.species} (${plantContext.scientificName})`
        : '';

      const prompt = `
        Analyze this plant image for health issues and provide a detailed diagnosis.${contextInfo}
        
        Please respond in JSON format with the following structure:
        {
          "healthAssessment": {
            "overallHealth": "healthy|minor_issues|major_issues|critical",
            "confidence": 0.85,
            "issues": [
              {
                "type": "leaf_spot",
                "severity": "medium",
                "description": "Dark spots on leaves indicating fungal infection",
                "confidence": 0.90,
                "affectedArea": "lower leaves",
                "recommendations": [
                  "Remove affected leaves",
                  "Improve air circulation",
                  "Apply fungicide if necessary"
                ]
              }
            ]
          },
          "careRecommendations": {
            "immediate": [
              "Isolate plant to prevent spread",
              "Remove affected leaves"
            ],
            "ongoing": [
              "Monitor watering schedule",
              "Ensure proper drainage"
            ],
            "preventive": [
              "Maintain consistent watering",
              "Provide adequate air circulation"
            ]
          },
          "suggestedReminders": [
            {
              "type": "treatment",
              "title": "Apply Treatment",
              "description": "Apply fungicide or recommended treatment",
              "frequency": "weekly",
              "daysInterval": 7,
              "recurring": true,
              "priority": "high"
            },
            {
              "type": "monitoring",
              "title": "Monitor Recovery",
              "description": "Check for improvement or spread of issues",
              "frequency": "daily",
              "daysInterval": 1,
              "recurring": true,
              "priority": "high"
            },
            {
              "type": "inspection",
              "title": "Health Check",
              "description": "Thorough inspection for new issues",
              "frequency": "weekly",
              "daysInterval": 7,
              "recurring": true,
              "priority": "medium"
            }
          ]
        }
      `;

      const imagePart = {
        inlineData: {
          data: imageData,
          mimeType: imageType
        }
      };

      console.log('🧠 [AI-SERVICE] 🚀 Calling Gemini API for diagnosis...');
      const startTime = Date.now();
      
      const result = await model.generateContent([prompt, imagePart]);
      const response = await result.response;
      const text = response.text();
      
      const aiCallTime = Date.now() - startTime;
      console.log('🧠 [AI-SERVICE] ✅ Gemini API response received', {
        responseTime: `${aiCallTime}ms`,
        responseLength: text.length
      });

      // Parse JSON from response
      console.log('🧠 [AI-SERVICE] 🔍 Parsing diagnosis JSON response...');
      const jsonMatch = text.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        const parsedResult = JSON.parse(jsonMatch[0]);
        console.log('🧠 [AI-SERVICE] ✅ Plant diagnosis complete!', {
          overallHealth: parsedResult,
          // issuesFound: parsedResult.healthAssessment?.issues?.length || 0,
          totalTime: `${Date.now() - startTime}ms`
        });
        return parsedResult;
      }

      console.error('🧠 [AI-SERVICE] ❌ Could not parse diagnosis response as JSON. Raw response:', text.substring(0, 200));
      throw new Error('Could not parse AI response as JSON');
    } catch (error) {
      console.error('🧠 [AI-SERVICE] ❌ Plant diagnosis error:', error.message);
      throw error;
    }
  }

  async generateCareAdvice(plantData, userQuery) {
    try {
      const model = this.genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

      const prompt = `
        You are a plant care expert. Based on the following plant information and user question, provide helpful advice.
        
        Plant Information:
        - Species: ${plantData.species}
        - Scientific Name: ${plantData.scientificName}
        - Current Health: ${plantData.healthStatus?.overall || 'unknown'}
        - Location: ${plantData.location?.room || 'unknown'}
        
        User Question: ${userQuery}
        
        Please provide a helpful, specific answer focusing on actionable advice. Keep the response conversational but informative.
      `;

      const result = await model.generateContent(prompt);
      const response = await result.response;
      return response.text();
    } catch (error) {
      console.error('Care advice generation error:', error);
      throw error;
    }
  }
}

module.exports = new AIService();
