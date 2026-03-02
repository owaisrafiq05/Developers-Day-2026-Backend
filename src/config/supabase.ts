import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'

dotenv.config()

const supabaseUrl        = process.env.SUPABASE_URL
const supabaseServiceKey = process.env.SECRET_API_KEY
const supabaseAnonKey    = process.env.PUBLISHABLE_API_KEY

if (!supabaseUrl || !supabaseServiceKey || !supabaseAnonKey) {
    throw new Error('[supabase]: SUPABASE_URL, SECRET_API_KEY, or PUBLISHABLE_API_KEY is missing from environment.')
}

export const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
    auth: {
        autoRefreshToken: false,
        persistSession: false,
    },
})

export const supabasePublic = createClient(supabaseUrl, supabaseAnonKey, {
    auth: {
        autoRefreshToken: false,
        persistSession: false,
    },
})
