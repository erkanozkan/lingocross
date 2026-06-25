const TOKEN_KEY = "lc_admin_token";
const EXPIRES_KEY = "lc_admin_expires";

export function setAuth(token: string, expiresAt: string): void {
  localStorage.setItem(TOKEN_KEY, token);
  localStorage.setItem(EXPIRES_KEY, expiresAt);
}

export function getToken(): string | null {
  return localStorage.getItem(TOKEN_KEY);
}

export function clearAuth(): void {
  localStorage.removeItem(TOKEN_KEY);
  localStorage.removeItem(EXPIRES_KEY);
}

/** Token var ve süresi geçmemiş mi? */
export function isAuthenticated(): boolean {
  const token = getToken();
  if (!token) return false;
  const expires = localStorage.getItem(EXPIRES_KEY);
  if (expires) {
    const exp = new Date(expires).getTime();
    if (!Number.isNaN(exp) && exp <= Date.now()) {
      clearAuth();
      return false;
    }
  }
  return true;
}
