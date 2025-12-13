// api/index.js
import { AthletesAPI } from "./athletes.js";
import { TournamentsAPI } from "./tournaments.js";
import { WodsAPI } from "./wods.js";
import { ScoresAPI } from "./scores.js";
import { JudgesAPI } from "./judges.js";

export const api = {
    athletes: AthletesAPI,
    tournaments: TournamentsAPI,
    wods: WodsAPI,
    scores: ScoresAPI,
    judges: JudgesAPI
};

// Also export individually for convenience
export { AthletesAPI, TournamentsAPI, WodsAPI, ScoresAPI, JudgesAPI };
