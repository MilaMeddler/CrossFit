-- ============================================
-- COMPLETE RLS SETUP FOR ATHLETE ENTRY PAGE
-- ============================================
-- Execute this entire script in Supabase SQL Editor
-- This will enable public read access to all necessary tables

-- 1. TOURNAMENTS TABLE
ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Enable read access for all users" ON tournaments;

CREATE POLICY "Enable read access for all users"
ON tournaments
FOR SELECT
USING (true);

-- 2. ATHLETES TABLE
ALTER TABLE athletes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Enable read access for all users" ON athletes;

CREATE POLICY "Enable read access for all users"
ON athletes
FOR SELECT
USING (true);

-- 3. WORKOUTS TABLE
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Enable read access for all users" ON workouts;

CREATE POLICY "Enable read access for all users"
ON workouts
FOR SELECT
USING (true);

-- ============================================
-- VERIFICATION QUERIES
-- ============================================
-- Run these to verify the policies were created correctly

-- Check all policies
SELECT tablename, policyname, cmd
FROM pg_policies
WHERE tablename IN ('tournaments', 'athletes', 'workouts')
ORDER BY tablename;

-- Count records in each table (should return numbers, not errors)
SELECT 'tournaments' as table_name, COUNT(*) as count FROM tournaments
UNION ALL
SELECT 'athletes' as table_name, COUNT(*) as count FROM athletes
UNION ALL
SELECT 'workouts' as table_name, COUNT(*) as count FROM workouts;

-- Show tournament names
SELECT id, name, created_at FROM tournaments ORDER BY created_at DESC;
