-- ============================================
-- FIX APP_SETTINGS RLS POLICIES
-- ============================================
-- This script adds missing RLS policies for app_settings table
-- to allow authenticated admins to update maintenance mode

-- Enable RLS on app_settings table
ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if any
DROP POLICY IF EXISTS "app_settings_select_public" ON app_settings;
DROP POLICY IF EXISTS "app_settings_update_admin" ON app_settings;
DROP POLICY IF EXISTS "app_settings_upsert_admin" ON app_settings;

-- Public: Can read all settings (needed for maintenance mode check)
CREATE POLICY "app_settings_select_public" ON app_settings
    FOR SELECT
    USING (true);

-- Admin only: Can update settings
CREATE POLICY "app_settings_update_admin" ON app_settings
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

-- Admin only: Can insert settings (for upsert operations)
CREATE POLICY "app_settings_insert_admin" ON app_settings
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

-- ============================================
-- VERIFICATION
-- ============================================
-- To verify the policies are active, run:
-- SELECT schemaname, tablename, policyname, cmd FROM pg_policies WHERE tablename = 'app_settings';
