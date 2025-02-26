import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://aacvoxossqxdkfahgsvc.supabase.co'; // From Step 1
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFhY3ZveG9zc3F4ZGtmYWhnc3ZjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA1MTQxODIsImV4cCI6MjA1NjA5MDE4Mn0.7fAjhgstdSf2EE7oarjvqvUPOHO5djqvS_g7zTvO2QY'; // From Step 1

export const supabase = createClient(supabaseUrl, supabaseAnonKey);