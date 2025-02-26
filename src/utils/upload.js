import { supabase } from "../supabase.js";

export async function uploadFile(file, bucket, path) {
  const { data, error } = await supabase.storage.from(bucket).upload(path, file);
  if (error) throw error;
  return data;
}