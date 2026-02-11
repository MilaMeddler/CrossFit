-- Enable public read access for athletes and workouts tables
-- This allows the athlete entry page to load athletes and WODs without authentication

-- Enable RLS for athletes (if not already enabled)
ALTER TABLE athletes ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Enable read access for all users" ON athletes;

-- Create policy for public read access to athletes
CREATE POLICY "Enable read access for all users"
ON athletes
FOR SELECT
USING (true);

-- Enable RLS for workouts (if not already enabled)
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Enable read access for all users" ON workouts;

-- Create policy for public read access to workouts
CREATE POLICY "Enable read access for all users"
ON workouts
FOR SELECT
USING (true);

-- Verify policies were created
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename IN ('athletes', 'workouts');
