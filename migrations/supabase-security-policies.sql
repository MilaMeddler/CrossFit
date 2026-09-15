-- ============================================
-- CROSSFIT COMPETITION - RLS SECURITY POLICIES
-- ============================================
-- This script sets up Row Level Security for all tables
--
-- Security Model:
-- - Public (anonymous): Can READ all data, Can INSERT/UPDATE scores
-- - Authenticated admins: Can do everything (INSERT/UPDATE/DELETE)
-- ============================================

-- First, enable RLS on all tables
ALTER TABLE athletes ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE judges ENABLE ROW LEVEL SECURITY;
ALTER TABLE scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;

-- ============================================
-- DROP EXISTING POLICIES (if any)
-- ============================================
DROP POLICY IF EXISTS "athletes_select_public" ON athletes;
DROP POLICY IF EXISTS "athletes_insert_admin" ON athletes;
DROP POLICY IF EXISTS "athletes_update_admin" ON athletes;
DROP POLICY IF EXISTS "athletes_delete_admin" ON athletes;

DROP POLICY IF EXISTS "tournaments_select_public" ON tournaments;
DROP POLICY IF EXISTS "tournaments_insert_admin" ON tournaments;
DROP POLICY IF EXISTS "tournaments_update_admin" ON tournaments;
DROP POLICY IF EXISTS "tournaments_delete_admin" ON tournaments;

DROP POLICY IF EXISTS "workouts_select_public" ON workouts;
DROP POLICY IF EXISTS "workouts_insert_admin" ON workouts;
DROP POLICY IF EXISTS "workouts_update_admin" ON workouts;
DROP POLICY IF EXISTS "workouts_delete_admin" ON workouts;

DROP POLICY IF EXISTS "teams_select_public" ON teams;
DROP POLICY IF EXISTS "teams_insert_admin" ON teams;
DROP POLICY IF EXISTS "teams_update_admin" ON teams;
DROP POLICY IF EXISTS "teams_delete_admin" ON teams;

DROP POLICY IF EXISTS "judges_select_public" ON judges;
DROP POLICY IF EXISTS "judges_insert_admin" ON judges;
DROP POLICY IF EXISTS "judges_update_admin" ON judges;
DROP POLICY IF EXISTS "judges_delete_admin" ON judges;

DROP POLICY IF EXISTS "scores_select_public" ON scores;
DROP POLICY IF EXISTS "scores_insert_public" ON scores;
DROP POLICY IF EXISTS "scores_update_admin" ON scores;
DROP POLICY IF EXISTS "scores_update_public" ON scores;
DROP POLICY IF EXISTS "scores_delete_admin" ON scores;

DROP POLICY IF EXISTS "tournament_participants_select_public" ON tournament_participants;
DROP POLICY IF EXISTS "tournament_participants_insert_admin" ON tournament_participants;
DROP POLICY IF EXISTS "tournament_participants_update_admin" ON tournament_participants;
DROP POLICY IF EXISTS "tournament_participants_delete_admin" ON tournament_participants;

DROP POLICY IF EXISTS "app_settings_select_public" ON app_settings;
DROP POLICY IF EXISTS "app_settings_insert_admin" ON app_settings;
DROP POLICY IF EXISTS "app_settings_update_admin" ON app_settings;

-- ============================================
-- ATHLETES TABLE
-- ============================================
-- Public: Can read all athletes
CREATE POLICY "athletes_select_public" ON athletes
    FOR SELECT
    USING (true);

-- Admin only: Insert, Update, Delete
CREATE POLICY "athletes_insert_admin" ON athletes
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "athletes_update_admin" ON athletes
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "athletes_delete_admin" ON athletes
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- TOURNAMENTS TABLE
-- ============================================
-- Public: Can read all tournaments
CREATE POLICY "tournaments_select_public" ON tournaments
    FOR SELECT
    USING (true);

-- Admin only: Insert, Update, Delete
CREATE POLICY "tournaments_insert_admin" ON tournaments
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "tournaments_update_admin" ON tournaments
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "tournaments_delete_admin" ON tournaments
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- WORKOUTS TABLE
-- ============================================
-- Public: Can read all workouts
CREATE POLICY "workouts_select_public" ON workouts
    FOR SELECT
    USING (true);

-- Admin only: Insert, Update, Delete
CREATE POLICY "workouts_insert_admin" ON workouts
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "workouts_update_admin" ON workouts
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "workouts_delete_admin" ON workouts
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- TEAMS TABLE
-- ============================================
-- Public: Can read all teams
CREATE POLICY "teams_select_public" ON teams
    FOR SELECT
    USING (true);

-- Admin only: Insert, Update, Delete
CREATE POLICY "teams_insert_admin" ON teams
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "teams_update_admin" ON teams
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "teams_delete_admin" ON teams
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- JUDGES TABLE
-- ============================================
-- Public: Can read all judges
CREATE POLICY "judges_select_public" ON judges
    FOR SELECT
    USING (true);

-- Admin only: Insert, Update, Delete
CREATE POLICY "judges_insert_admin" ON judges
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "judges_update_admin" ON judges
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "judges_delete_admin" ON judges
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- SCORES TABLE (SPECIAL CASE)
-- ============================================
-- Public: Can read all scores
CREATE POLICY "scores_select_public" ON scores
    FOR SELECT
    USING (true);

-- Public: Can INSERT scores (athletes can submit results)
CREATE POLICY "scores_insert_public" ON scores
    FOR INSERT
    WITH CHECK (true);

-- Public: Can UPDATE scores (judges can modify results)
CREATE POLICY "scores_update_public" ON scores
    FOR UPDATE
    USING (true)
    WITH CHECK (true);

-- Admin only: Delete
CREATE POLICY "scores_delete_admin" ON scores
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- TOURNAMENT PARTICIPANTS TABLE
-- ============================================
-- Public: Can read all tournament participants
CREATE POLICY "tournament_participants_select_public" ON tournament_participants
    FOR SELECT
    USING (true);

-- Admin only: Insert, Update, Delete
CREATE POLICY "tournament_participants_insert_admin" ON tournament_participants
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "tournament_participants_update_admin" ON tournament_participants
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "tournament_participants_delete_admin" ON tournament_participants
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- APP_SETTINGS TABLE
-- ============================================
-- Public: Can read all settings (needed for maintenance mode check)
CREATE POLICY "app_settings_select_public" ON app_settings
    FOR SELECT
    USING (true);

-- Admin only: Can insert settings (for upsert operations)
CREATE POLICY "app_settings_insert_admin" ON app_settings
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

-- Admin only: Can update settings
CREATE POLICY "app_settings_update_admin" ON app_settings
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

-- ============================================
-- VERIFICATION QUERIES
-- ============================================
-- Run these to verify the policies are active:

-- Check RLS is enabled:
-- SELECT tablename, rowsecurity FROM pg_tables WHERE schemaname = 'public';

-- Check policies:
-- SELECT schemaname, tablename, policyname, cmd FROM pg_policies WHERE schemaname = 'public';

-- ============================================
-- NOTES
-- ============================================
-- 1. This setup allows:
--    - Anyone (anon) can READ all data
--    - Anyone (anon) can INSERT/UPDATE scores (athlete self-entry and judge modifications)
--    - Only authenticated users can DELETE scores
--    - Only authenticated users can INSERT/UPDATE/DELETE athletes, tournaments, tournament_participants, etc.
--    - Only authenticated users can UPDATE app_settings (maintenance mode)
--
-- 2. The "scores_insert_public" and "scores_update_public" policies allow:
--    - athlete.html to work (INSERT scores)
--    - judge.html to work (INSERT and UPDATE scores)
--    - Only DELETE requires authentication
--
-- 3. After applying these policies:
--    - athlete.html will work (INSERT scores)
--    - judge.html will work (INSERT and UPDATE scores)
--    - leaderboard.html will work (SELECT scores)
--    - admin.html requires Supabase authentication
--    - Maintenance mode toggle requires authentication
--
-- 4. IMPORTANT: Make sure to create admin users in Supabase Auth!
--    Dashboard > Authentication > Users > Add user
