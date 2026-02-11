-- ============================================
-- CLEAN UP AND FIX RLS POLICIES
-- ============================================
-- This will remove ALL existing policies and create only the correct ones

-- TOURNAMENTS TABLE
-- Drop ALL existing policies
DROP POLICY IF EXISTS "Enable read access for all users" ON tournaments;
DROP POLICY IF EXISTS "tournaments_select_policy" ON tournaments;
DROP POLICY IF EXISTS "tournaments_insert_policy" ON tournaments;
DROP POLICY IF EXISTS "tournaments_update_policy" ON tournaments;
DROP POLICY IF EXISTS "tournaments_delete_policy" ON tournaments;

-- Disable RLS temporarily
ALTER TABLE tournaments DISABLE ROW LEVEL SECURITY;

-- Re-enable RLS
ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;

-- Create ONLY the public read policy
CREATE POLICY "Public read access"
ON tournaments
FOR SELECT
TO anon, authenticated
USING (true);

-- ATHLETES TABLE
-- Drop ALL existing policies
DROP POLICY IF EXISTS "Enable read access for all users" ON athletes;
DROP POLICY IF EXISTS "athletes_select_policy" ON athletes;
DROP POLICY IF EXISTS "athletes_insert_policy" ON athletes;
DROP POLICY IF EXISTS "athletes_update_policy" ON athletes;
DROP POLICY IF EXISTS "athletes_delete_policy" ON athletes;

-- Disable RLS temporarily
ALTER TABLE athletes DISABLE ROW LEVEL SECURITY;

-- Re-enable RLS
ALTER TABLE athletes ENABLE ROW LEVEL SECURITY;

-- Create ONLY the public read policy
CREATE POLICY "Public read access"
ON athletes
FOR SELECT
TO anon, authenticated
USING (true);

-- WORKOUTS TABLE
-- Drop ALL existing policies
DROP POLICY IF EXISTS "Enable read access for all users" ON workouts;
DROP POLICY IF EXISTS "workouts_select_policy" ON workouts;
DROP POLICY IF EXISTS "workouts_insert_policy" ON workouts;
DROP POLICY IF EXISTS "workouts_update_policy" ON workouts;
DROP POLICY IF EXISTS "workouts_delete_policy" ON workouts;

-- Disable RLS temporarily
ALTER TABLE workouts DISABLE ROW LEVEL SECURITY;

-- Re-enable RLS
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;

-- Create ONLY the public read policy
CREATE POLICY "Public read access"
ON workouts
FOR SELECT
TO anon, authenticated
USING (true);

-- SCORES TABLE (also needs public read for leaderboard)
-- Drop ALL existing policies
DROP POLICY IF EXISTS "Enable read access for all users" ON scores;
DROP POLICY IF EXISTS "scores_select_policy" ON scores;
DROP POLICY IF EXISTS "scores_insert_policy" ON scores;
DROP POLICY IF EXISTS "scores_update_policy" ON scores;
DROP POLICY IF EXISTS "scores_delete_policy" ON scores;

-- Disable RLS temporarily
ALTER TABLE scores DISABLE ROW LEVEL SECURITY;

-- Re-enable RLS
ALTER TABLE scores ENABLE ROW LEVEL SECURITY;

-- Create public read policy
CREATE POLICY "Public read access"
ON scores
FOR SELECT
TO anon, authenticated
USING (true);

-- Create authenticated insert policy (for athlete/judge entry)
CREATE POLICY "Authenticated insert access"
ON scores
FOR INSERT
TO authenticated
WITH CHECK (true);

-- ============================================
-- VERIFICATION
-- ============================================
-- Check that we have exactly 1 SELECT policy per table

SELECT
    tablename,
    COUNT(*) as policy_count,
    STRING_AGG(policyname, ', ') as policies
FROM pg_policies
WHERE tablename IN ('tournaments', 'athletes', 'workouts', 'scores')
GROUP BY tablename
ORDER BY tablename;

-- Test reading from each table
SELECT 'Tournaments:' as test, COUNT(*) as count FROM tournaments
UNION ALL
SELECT 'Athletes:' as test, COUNT(*) as count FROM athletes
UNION ALL
SELECT 'Workouts:' as test, COUNT(*) as count FROM workouts
UNION ALL
SELECT 'Scores:' as test, COUNT(*) as count FROM scores;
