// api/tournaments.js
import { supabase } from "../supabase.js";

export const TournamentsAPI = {
    async getAll() {
        const { data, error } = await supabase
            .from("tournaments")
            .select("*")
            .order("date_start", { ascending: false });

        if (error) throw error;
        return data;
    },

    async getById(id) {
        const { data, error } = await supabase
            .from("tournaments")
            .select("*")
            .eq("id", id)
            .single();

        if (error) throw error;
        return data;
    },

    async create(tournament) {
        const { data, error } = await supabase
            .from("tournaments")
            .insert(tournament)
            .select()
            .single();

        if (error) throw error;
        return data;
    },

    async update(id, dataUpdate) {
        const { data, error } = await supabase
            .from("tournaments")
            .update(dataUpdate)
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
