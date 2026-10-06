export const RESET_CODE_TTL_MINUTES = 15;
export const RESET_CODE_MAX_ATTEMPTS = 5;
// Une nouvelle demande pour le même compte est ignorée pendant ce délai
// (évite de bombarder une boîte mail depuis plusieurs IP)
export const RESET_CODE_RESEND_COOLDOWN_MS = 60 * 1000;
