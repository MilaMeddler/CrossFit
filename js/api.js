// js/api.js
// ====================================
// Supabase API client for CrossFit Tournament
// Assumes window.CONFIG contains SUPABASE_URL and SUPABASE_ANON_KEY
// ====================================

if (!window.CONFIG || !window.CONFIG.SUPABASE_URL || !window.CONFIG.SUPABASE_ANON_KEY) {
    console.error('CONFIG with SUPABASE_URL and SUPABASE_ANON_KEY is required (config.js).');
}

const supabase = window.supabase && window.supabase.createClient
    ? window.supabase.createClient(window.CONFIG.SUPABASE_URL, window.CONFIG.SUPABASE_ANON_KEY)
    : null;

if (!supabase) {
    console.error('Supabase client not initialized. Make sure you included <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script> & config.js before api.js');
}

// Unified API class
class CrossFitAPI {
    constructor() {
        if (!supabase) throw new Error('Supabase not initialized');
        console.log('✅ Supabase API initialized');
    }

    // ---------------------
    // Tournaments
    // ---------------------
    async getTournaments() {
        const { data, error } = await supabase
            .from('tournaments')
            .select('*')
            .order('id', { ascending: true });
        if (error) throw error;
        return data;
    }

    async addTournament(tournament) {
        // tournament: { name, date_start, date_end, location }
        const { data, error } = await supabase
            .from('tournaments')
            .insert(tournament)
            .select();
        if (error) throw error;
        return data[0];
    }

    async deleteTournament(id) {
        const { error } = await supabase
            .from('tournaments')
            .delete()
            .eq('id', id);
        if (error) throw error;
        return true;
    }

    // ---------------------
    // Workouts (WOD)
    // ---------------------
    async getWorkouts(tournament_id) {
        const { data, error } = await supabase
            .from('workouts')
            .select('*')
            .eq('tournament_id', tournament_id)
            .order('wod_number', { ascending: true });
        if (error) throw error;
        return data;
    }

    async addWorkout(wod) {
        // wod: { tournament_id, wod_number, wod_type, description }
        const { data, error } = await supabase
            .from('workouts')
            .insert(wod)
            .select();
        if (error) throw error;
        return data[0];
    }

    async deleteWorkout(id) {
        const { error } = await supabase
            .from('workouts')
            .delete()
            .eq('id', id);
        if (error) throw error;
        return true;
    }

    // ---------------------
    // Athletes
    // ---------------------
    async getAthletes(tournament_id) {
        const { data, error } = await supabase
            .from('athletes')
            .select('*')
            .eq('tournament_id', tournament_id)
            .order('id', { ascending: true });
        if (error) throw error;
        return data;
    }

    async addAthlete(athlete) {
        // athlete: { tournament_id, first_name, last_name, gender, birthdate, level, team }
        const { data, error } = await supabase
            .from('athletes')
            .insert(athlete)
            .select();
        if (error) throw error;
        return data[0];
    }

    async updateAthlete(id, payload) {
        const { data, error } = await supabase
            .from('athletes')
            .update(payload)
            .eq('id', id)
            .select();
        if (error) throw error;
        return data[0];
    }

    async deleteAthlete(id) {
        const { error } = await supabase
            .from('athletes')
            .delete()
            .eq('id', id);
        if (error) throw error;
        return true;
    }

    // ---------------------
    // Scores (Results)
    // ---------------------
    async getResults(tournament_id) {
        // get all scores for a tournament (via workouts -> tournament_id)
        // Efficient way: query scores and join workouts to filter by tournament_id
        const { data, error } = await supabase
            .from('scores')
            .select('*, workouts!inner(tournament_id)')
            .eq('workouts.tournament_id', tournament_id)
            .order('id', { ascending: true });
        if (error) throw error;
        // data includes workout object with tournament_id; we return plain scores
        return data;
    }

    async addResult(result) {
        // result: { athlete_id, workout_id, judge_id, value_int, value_time, value_decimal, notes }
        const { data, error } = await supabase
            .from('scores')
            .insert(result)
            .select();
        if (error) throw error;
        return data[0];
    }

    async updateResult(id, payload) {
        const { data, error } = await supabase
            .from('scores')
            .update(payload)
            .eq('id', id)
            .select();
        if (error) throw error;
        return data[0];
    }

    async deleteResult(id) {
        const { error } = await supabase
            .from('scores')
            .delete()
            .eq('id', id);
        if (error) throw error;
        return true;
    }

    // ---------------------
    // Judges
    // ---------------------
    async getJudges() {
        const { data, error } = await supabase
            .from('judges')
            .select('*')
            .order('id', { ascending: true });
        if (error) throw error;
        return data;
    }

    async addJudge(j) {
        const { data, error } = await supabase
            .from('judges')
            .insert(j)
            .select();
        if (error) throw error;
        return data[0];
    }

    // ---------------------
    // Convenience: getAllData for UI (per tournament)
    // ---------------------
    async getAllData(tournament_id) {
        const [athletes, workouts, results, judges] = await Promise.all([
            this.getAthletes(tournament_id),
            this.getWorkouts(tournament_id),
            this.getResults(tournament_id),
            this.getJudges()
        ]);
        return { athletes, workouts, results, judges };
    }
}

// expose instance
let api = null;
function initAPI() {
    if (!supabase) throw new Error('Supabase not initialized');
    api = new CrossFitAPI();
    return api;
}

// export to window
window.CrossFitAPI = CrossFitAPI;
window.api = api;        // will be set when initAPI called

// auto init when file loaded (if config present)
try {
    if (window.CONFIG && window.CONFIG.SUPABASE_URL && window.CONFIG.SUPABASE_ANON_KEY && window.supabase) {
        initAPI();
        window.api = api;
    }
} catch (err) {
    console.warn('API init skipped:', err.message);
}
