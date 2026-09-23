-- Add published flag to workouts
-- Run in Supabase SQL Editor

ALTER TABLE workouts
    ADD COLUMN IF NOT EXISTS published BOOLEAN NOT NULL DEFAULT FALSE;

COMMENT ON COLUMN workouts.published IS
'When true, this WOD is visible to judges and on the leaderboard.
False = draft: only admins see it.';
