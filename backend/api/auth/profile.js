const { getSupabase } = require('../../lib/database');
const Profile = require('../../models/Profile');

module.exports = async (req, res) => {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, PUT, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (!['GET', 'PUT'].includes(req.method)) {
    return res.status(405).json({
      success: false,
      message: 'Method not allowed'
    });
  }

  try {
    const supabase = getSupabase();

    // Get the authorization header
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'No authorization token provided'
      });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    // Verify the token and get user
    const { data: { user }, error: authError } = await supabase.auth.getUser(token);

    if (authError || !user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid or expired token'
      });
    }

    if (req.method === 'GET') {
      // Get user profile
      const profile = await Profile.findByUserId(user.id);

      if (!profile) {
        return res.status(404).json({
          success: false,
          message: 'Profile not found'
        });
      }

      res.status(200).json({
        success: true,
        data: {
          user: {
            id: user.id,
            email: user.email,
            ...profile
          }
        }
      });

    } else if (req.method === 'PUT') {
      // Update user profile
      const { name, avatar, preferences } = req.body;

      if (!name) {
        return res.status(400).json({
          success: false,
          message: 'Name is required'
        });
      }

      const updateData = {
        name: name.trim(),
        ...(avatar !== undefined && { avatar }),
        ...(preferences && { preferences })
      };

      const updatedProfile = await Profile.updateByUserId(user.id, updateData);

      res.status(200).json({
        success: true,
        message: 'Profile updated successfully',
        data: {
          user: {
            id: user.id,
            email: user.email,
            ...updatedProfile
          }
        }
      });
    }

  } catch (error) {
    console.error('Profile API error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to process profile request',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};