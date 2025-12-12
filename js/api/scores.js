// api/scores.js
import { supabase } from "./supabase.js";

export const ScoresAPI = {
    async getByTournament(tournament_id) {
        const { data, error } = await supabase
            .from("scores")
            .select(`
                id,
                athlete_id,
                workout_id,
                judge_id,
                value_int,
                value_time,
                value_decimal,
                notes,
                submitted_at,
                workouts:tournament_id
            `);

        if (error) throw error;

        // Фильтр на клиенте — безопасно и быстро
        return data.filter(s => s.workouts?.tournament_id === tournament_id);
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

    async update(id, updateData) {
        const { data, error } = await supabase
            .from("scores")
            .update(updateData)
            .eq("id", id)
            .select()
            .single();

        if (error) throw error;
        return data;
    },

    async delete(id) {
        const { error } = await supabase
            .from("scores")
            .delete()
            .eq("id", id);

        if (error) throw error;
        return true;
    }
};
