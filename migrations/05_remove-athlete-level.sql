-- ============================================
-- REMOVE level COLUMN FROM athletes TABLE
-- ============================================
-- This migration removes the 'level' column from athletes table
-- Division/level is now stored in tournament_participants table
-- per tournament, not globally per athlete
-- ============================================

-- Remove the level column if it exists
ALTER TABLE athletes
    DROP COLUMN IF EXISTS level;

-- ============================================
-- VERIFICATION
-- ============================================
-- Check the column was removed:
-- SELECT column_name FROM information_schema.columns
-- WHERE table_name = 'athletes' AND column_name = 'level';
-- (should return no rows)
