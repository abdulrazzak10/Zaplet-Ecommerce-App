import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zaplet/data/models/user_model.dart';
import 'package:zaplet/data/services/supabase_service.dart';
import 'package:go_router/go_router.dart';
import 'package:zaplet/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

abstract class AuthRepository {
  Future<UserModel> signUp({required String email, required String password, String? fullName});
  Future<UserModel> signIn({required String email, required String password});
  Future<void> signOut(BuildContext context);
  Future<UserModel?> getCurrentUser();
  Stream<AuthState> authStateChanges();
  Future<void> resetPassword(String email);
  Future<UserModel> updateUserProfile({required String fullName});
}

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client = SupabaseService.client;

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Failed to sign up');
      }
      
      // Create user profile
      final userData = {
        'id': response.user!.id,
        'email': email,
        'full_name': fullName,
        'role': 'user',
      };
      
      await _client.from('users').insert(userData);
      
      return UserModel(
        id: response.user!.id,
        email: email,
        fullName: fullName,
        role: 'user',
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Failed to sign in');
      }
      
      // Get user profile
      final userData = await _client
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();
      
      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut(BuildContext context) async {
    try {
      await _client.auth.signOut();
      if (context.mounted) {
        context.go(AppRoutes.login);
      }
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      
      if (user == null) {
        return null;
      }
      
      final userData = await _client
          .from('users')
          .select()
          .eq('id', user.id)
          .single();
      
      return UserModel.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<AuthState> authStateChanges() {
    return _client.auth.onAuthStateChange;
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> updateUserProfile({required String fullName}) async {
    try {
      final user = _client.auth.currentUser;
      
      if (user == null) {
        throw Exception('No authenticated user');
      }
      
      await _client.from('users').update({
        'full_name': fullName,
      }).eq('id', user.id);
      
      final userData = await _client
          .from('users')
          .select()
          .eq('id', user.id)
          .single();
      
      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception('Profile update failed: ${e.toString()}');
    }
  }
} 