-- ============================================
-- ADD CROSSFIT OPEN FORMAT SUPPORT
-- ============================================
-- Run this script AFTER the previous SQL scripts
-- ============================================

-- 1. Add is_open flag to tournaments table
ALTER TABLE tournaments
    ADD COLUMN IF NOT EXISTS is_open BOOLEAN DEFAULT FALSE;

-- 2. Add division, tiebreak_time, is_completed to scores table
ALTER TABLE scores
    ADD COLUMN IF NOT EXISTS division VARCHAR(20);
    -- Values: 'rx', 'scaled', 'foundations'

ALTER TABLE scores
    ADD COLUMN IF NOT EXISTS tiebreak_time INTEGER;
    -- Tiebreak time in seconds

ALTER TABLE scores
    ADD COLUMN IF NOT EXISTS is_completed BOOLEAN DEFAULT TRUE;
    -- For Time WODs: true if fully completed, false if time cap hit

-- ============================================
-- VERIFICATION
-- ============================================
-- Check tournaments table:
-- SELECT id, name, is_open FROM tournaments;

-- Check scores table has new columns:
-- SELECT column_name FROM information_schema.columns
-- WHERE table_name = 'scores' AND column_name IN ('division', 'tiebreak_time', 'is_completed');
