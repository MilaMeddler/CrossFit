// api/tournaments.js
import { supabase } from "./supabase.js";

export const TournamentsAPI = {
    async getAll() {
        const { data, error } = await supabase
            .from("tournaments")
            .select("*")
            .order("id");

        if (error) throw error;
        return data;
    },

    async create(t) {
        const { data, error } = await supabase
            .from("tournaments")
            .insert(t)
            .select()
            .single();

        if (error) throw error;
        return data;
    },

    async update(id, updateData) {
        const { data, error } = await supabase
            .from("tournaments")
            .update(updateData)
            .eq("id", id)
            .select()
            .single();

        if (error) throw error;
        return data;
    },

    async delete(id) {
        const { error } = await supabase
            .from("tournaments")
            .delete()
            .eq("id", id);

        if (error) throw error;
        return true;
    }
};
