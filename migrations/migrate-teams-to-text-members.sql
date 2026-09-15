-- Migration: replace FK athlete columns with text array of member names
-- Run in Supabase SQL Editor BEFORE deploying updated code

-- Step 1: remove FK columns
ALTER TABLE teams DROP COLUMN IF EXISTS athlete1_id;
ALTER TABLE teams DROP COLUMN IF EXISTS athlete2_id;

-- Step 2: add text array column
ALTER TABLE teams ADD COLUMN IF NOT EXISTS member_names TEXT[] NOT NULL DEFAULT '{}';

-- Step 3: allow public self-registration (insert) on teams
DROP POLICY IF EXISTS "teams_insert_admin" ON teams;
DROP POLICY IF EXISTS "teams_insert_public" ON teams;
CREATE POLICY "teams_insert_public" ON teams
    FOR INSERT TO anon, authenticated
    WITH CHECK (true);
