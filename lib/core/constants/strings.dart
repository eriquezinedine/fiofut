/// Prefijo para IDs temporales que aún no existen en Supabase.
///
/// Se usa cuando se crea una serie o schedule localmente antes de
/// recibir el ID real del backend. Cualquier ID que empiece con este
/// prefijo se salta la sincronización a Supabase para evitar queries
/// con IDs inexistentes.
const kPendingPrefix = 'pending_';
