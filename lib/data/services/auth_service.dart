import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zaplet/data/services/supabase_service.dart';

class AuthService {
  // Try to get client with error handling
  SupabaseClient? _getClient() {
    try {
      return SupabaseService.client;
    } catch (e) {
      debugPrint('Error getting Supabase client: $e');
      return null;
    }
  }

  // Get current user
  User? get currentUser {
    try {
      final client = _getClient();
      return client?.auth.currentUser;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  // Get current session
  Session? get currentSession {
    try {
      final client = _getClient();
      return client?.auth.currentSession;
    } catch (e) {
      debugPrint('Error getting current session: $e');
      return null;
    }
  }

  // Stream of auth state changes
  Stream<AuthState> get authStateChanges {
    final client = _getClient();
    if (client == null) {
      return Stream.empty();
    }
    return client.auth.onAuthStateChange;
  }

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // First ensure connection
      final isConnected = await SupabaseService.testConnection();
      if (!isConnected) {
        throw Exception('Unable to connect to the server. Please check your internet connection.');
      }

      final client = _getClient();
      if (client == null) {
        throw Exception('Authentication service is not available');
      }

      debugPrint('Starting signup for: $email');
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user != null) {
        debugPrint('User created: ${response.user?.id}');
        return response;
      }

      debugPrint('Failed to create user account: ${response.session}');
      throw Exception('Failed to create user account');
    } catch (e) {
      debugPrint('Auth error during sign up: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // First ensure connection
      final isConnected = await SupabaseService.testConnection();
      if (!isConnected) {
        throw Exception('Unable to connect to the server. Please check your internet connection.');
      }

      final client = _getClient();
      if (client == null) {
        throw Exception('Authentication service is not available');
      }

      debugPrint('Starting login for: $email');
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      debugPrint('Login successful: ${response.user?.id}');
      return response;
    } catch (e) {
      debugPrint('Auth error during sign in: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final client = _getClient();
      if (client == null) {
        throw Exception('Authentication service is not available');
      }
      await client.auth.signOut();
    } catch (e) {
      debugPrint('Error during sign out: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      final client = _getClient();
      if (client == null) {
        throw Exception('Authentication service is not available');
      }
      await client.auth.resetPasswordForEmail(email);
    } catch (e) {
      debugPrint('Error resetting password: $e');
      rethrow;
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      final client = _getClient();
      if (client == null) {
        throw Exception('Authentication service is not available');
      }
      await client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      debugPrint('Error updating password: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final client = _getClient();
      if (client == null) {
        throw Exception('Authentication service is not available');
      }
      
      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      await client.from('profiles')
          .update(updates)
          .eq('id', userId);
    } catch (e) {
      debugPrint('Error updating profile: $e');
      rethrow;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final client = _getClient();
      if (client == null) {
        throw Exception('Authentication service is not available');
      }
      
      final response = await client.from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  // Check if user is an admin
  Future<bool> isAdmin() async {
    try {
      final client = _getClient();
      if (client == null || currentUser == null) {
        return false;
      }
      
      final response = await client.from('profiles')
          .select('is_admin')
          .eq('id', currentUser!.id)
          .single();
      
      return response != null && response['is_admin'] == true;
    } catch (e) {
      debugPrint('Error checking admin status: $e');
      return false;
    }
  }
  
  // Get user role (admin or regular user)
  Future<String> getUserRole() async {
    if (await isAdmin()) {
      return 'admin';
    } else {
      return 'user';
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final client = _getClient();
      if (client == null) {
        throw Exception('Authentication service is not available');
      }
      
      // First delete from profiles table
      await client.from('profiles').delete().eq('id', userId);
      
      // Then delete from auth.users
      await client.auth.admin.deleteUser(userId);
    } catch (e) {
      debugPrint('Failed to delete user: $e');
      throw Exception('Failed to delete user: ${e.toString()}');
    }
  }
} 