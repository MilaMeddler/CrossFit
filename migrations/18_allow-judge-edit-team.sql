-- Allow judges (anon) to edit team name and member names
-- SECURITY DEFINER so anon can only update these two fields

CREATE OR REPLACE FUNCTION update_team_info(
    p_team_id bigint,
    p_team_name text,
    p_member_names text[]
)
RETURNS void
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
    UPDATE teams
    SET team_name    = p_team_name,
        member_names = p_member_names
    WHERE id = p_team_id;
$$;

GRANT EXECUTE ON FUNCTION update_team_info(bigint, text, text[]) TO anon;
