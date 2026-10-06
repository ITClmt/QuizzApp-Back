import { RESET_CODE_TTL_MINUTES } from 'src/auth/constants';

const copy = {
	fr: {
		subject: 'Ton code de réinitialisation QuizzApp',
		intro: 'Voici ton code pour réinitialiser ton mot de passe :',
		expiry: `Il expire dans ${RESET_CODE_TTL_MINUTES} minutes.`,
		ignore:
			"Si tu n'es pas à l'origine de cette demande, ignore cet e-mail : ton mot de passe reste inchangé.",
	},
	en: {
		subject: 'Your QuizzApp reset code',
		intro: 'Here is your code to reset your password:',
		expiry: `It expires in ${RESET_CODE_TTL_MINUTES} minutes.`,
		ignore:
			"If you didn't request this, ignore this email: your password stays unchanged.",
	},
};

export function passwordResetEmail(code: string, lang: string) {
	const t = lang === 'fr' ? copy.fr : copy.en;

	const html = `<!doctype html>
<html>
  <body style="margin:0;padding:24px;background:#EAF7FD;font-family:Arial,Helvetica,sans-serif;color:#1F2937;">
    <div style="max-width:480px;margin:0 auto;background:#FFFFFF;border-radius:12px;padding:32px;">
      <h1 style="margin:0 0 16px;font-size:20px;">QuizzApp</h1>
      <p style="margin:0 0 16px;font-size:15px;">${t.intro}</p>
      <p style="margin:0 0 16px;font-size:32px;font-weight:bold;letter-spacing:8px;text-align:center;">${code}</p>
      <p style="margin:0 0 16px;font-size:14px;">${t.expiry}</p>
      <p style="margin:0;font-size:13px;color:#6B7280;">${t.ignore}</p>
    </div>
  </body>
</html>`;

	const text = `${t.intro}\n\n${code}\n\n${t.expiry}\n\n${t.ignore}`;

	return { subject: t.subject, html, text };
}
