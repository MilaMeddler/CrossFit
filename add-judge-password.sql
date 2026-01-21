-- Add judge_password column to tournaments table
ALTER TABLE tournaments
ADD COLUMN IF NOT EXISTS judge_password TEXT;

-- Add comment explaining the column
COMMENT ON COLUMN tournaments.judge_password IS 'Password for judges to access result entry for this tournament';
