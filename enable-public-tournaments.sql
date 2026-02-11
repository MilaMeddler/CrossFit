-- Enable public read access for tournaments table
-- This allows athletes to see available tournaments without authentication

-- Enable RLS (if not already enabled)
ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;

-- Drop existing policy if exists
DROP POLICY IF EXISTS "Enable read access for all users" ON tournaments;

-- Create policy for public read access
CREATE POLICY "Enable read access for all users"
ON tournaments
FOR SELECT
USING (true);

-- Verify policy was created
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'tournaments';
