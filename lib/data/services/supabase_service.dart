import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Load environment variables
      await dotenv.load();
      
      // Initialize Supabase
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: kDebugMode,
      );
      _isInitialized = true;
      debugPrint('Supabase initialized successfully');
    } catch (e) {
      debugPrint('Critical error initializing Supabase: $e');
      _isInitialized = false;
      rethrow;
    }
  }
  
  static Future<bool> testConnection() async {
    if (!_isInitialized) {
      try {
        await initialize();
      } catch (e) {
        debugPrint('Failed to initialize Supabase: $e');
        return false;
      }
    }
    
    try {
      // Try a simple query to test the connection
      await client.from('profiles').select('id').limit(1).maybeSingle();
      return true;
    } catch (e) {
      debugPrint('Supabase connection test failed: $e');
      return false;
    }
  }

  static SupabaseClient get client {
    if (!_isInitialized) {
      // Attempt to initialize if not already done
      try {
        Supabase.initialize(
          url: supabaseUrl, 
          anonKey: supabaseAnonKey,
        );
        _isInitialized = true;
      } catch (e) {
        debugPrint('Error in lazy initialization: $e');
        rethrow;
      }
    }
    return Supabase.instance.client;
  }
} 