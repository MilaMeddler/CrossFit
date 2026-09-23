-- Allow judges (anon) to toggle workout visibility
-- Uses a SECURITY DEFINER function so anon can only update the `published`
-- column — not any other field on workouts.

CREATE OR REPLACE FUNCTION toggle_workout_published(workout_id bigint, new_published boolean)
RETURNS void
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
    UPDATE workouts SET published = new_published WHERE id = workout_id;
$$;

GRANT EXECUTE ON FUNCTION toggle_workout_published(bigint, boolean) TO anon;
