// api/wods.js
import { supabase } from "./supabase.js";

export const WodsAPI = {
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

    async update(id, updateData) {
        const { data, error } = await supabase
            .from("workouts")
            .update(updateData)
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
