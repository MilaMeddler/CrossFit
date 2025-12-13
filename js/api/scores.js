// api/scores.js
import { supabase } from "../supabase.js";

export const ScoresAPI = {
    // Get all scores with related data
    async getAll() {
        const { data, error } = await supabase
            .from("scores")
            .select(`
                *,
                athletes(id, first_name, last_name, gender, level),
                workouts(id, wod_number, wod_type, tournament_id),
                judges(id, name)
            `)
            .order("id");

        if (error) throw error;
        return data;
    },

    // Get scores for specific tournament
    async getByTournament(tournament_id) {
        const { data, error } = await supabase
            .from("scores")
            .select(`
                *,
                athletes(id, first_name, last_name, gender, level),
                workouts!inner(id, wod_number, wod_type, tournament_id),
                judges(id, name)
            `)
            .eq("workouts.tournament_id", tournament_id)
            .order("id");

        if (error) throw error;
        return data;
    },

    // Get scores for specific workout
    async getByWorkout(workout_id) {
        const { data, error } = await supabase
            .from("scores")
            .select(`
                *,
                athletes(id, first_name, last_name, gender, level),
                judges(id, name)
            `)
            .eq("workout_id", workout_id)
            .order("value_time");

        if (error) throw error;
        return data;
    },

    async create(score) {
        const { data, error } = await supabase
            .from("scores")
            .insert(score)
            .select()
            .single();

        if (error) throw error;
        return data;
    },

    async update(id, dataUpdate) {
        const { data, error } = await supabase
            .from("scores")
            .update(dataUpdate)
            .eq("id", id)
            .select()
            .single();

        if (error) throw error;
        return data;
    },
