-- Store individual athlete weights for team weight WODs
-- value_int stores the team total (sum), member_weights stores each athlete's lift

ALTER TABLE scores ADD COLUMN IF NOT EXISTS member_weights integer[];
