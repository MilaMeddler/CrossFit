// api/wods.js
import { supabase } from "../supabase.js";

export const WodsAPI = {
    // Get all WODs
    async getAll() {
        const { data, error } = await supabase
            .from("workouts")
            .select("*")
            .order("wod_number");

        if (error) throw error;
        return data;
    },

    // Get WODs for specific tournament
    async getByTournament(tournament_id) {
        const { data, error } = await supabase
            .from("workouts")
            .select("*")
            .eq("tournament_id", tournament_id)
            .order("wod_number");

        if (error) throw error;
        return data;
    },

    async create(wod) {
        const { data, error } = await supabase
            .from("workouts")
            .insert(wod)
            .select()
            .single();

        if (error) throw error;
        return data;
    },

    async update(id, dataUpdate) {
        const { data, error } = await supabase
            .from("workouts")
            .update(dataUpdate)
            .eq("id", id)
            .select()
            .single();

        if (error) throw error;
        return data;
    },

    async delete(id) {
        const { error } = await supabase
            .from("workouts")
            .delete()
            .eq("id", id);

        if (error) throw error;
        return true;
    }
};
