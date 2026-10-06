import { Injectable, Logger, OnModuleInit } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { passwordResetEmail } from "./templates/password-reset";

const RESEND_API_URL = "https://api.resend.com/emails";

@Injectable()
export class MailService implements OnModuleInit {
  private readonly logger = new Logger(MailService.name);

  constructor(private readonly configService: ConfigService) {}

  // Sans clé (dev local), les e-mails ne partent pas : leur contenu utile est
  // loggé à la place. En prod, on le signale dès le démarrage plutôt qu'au
  // premier "je n'ai jamais reçu le code".
  onModuleInit() {
    if (
      !this.configService.get<string>("RESEND_API_KEY") &&
      process.env.NODE_ENV === "production"
    ) {
      this.logger.warn("RESEND_API_KEY missing : no email will be sent");
    }
  }

  async sendPasswordResetCode(to: string, code: string, lang: string) {
    const apiKey = this.configService.get<string>("RESEND_API_KEY");
    if (!apiKey) {
      this.logger.log(`[dev] Password reset code for ${to} : ${code}`);
      return;
    }

    const { subject, html, text } = passwordResetEmail(code, lang);

    const response = await fetch(RESEND_API_URL, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        from: this.configService.getOrThrow<string>("MAIL_FROM"),
        to,
        subject,
        html,
        text,
      }),
    });

    if (!response.ok) {
      throw new Error(
        `Resend refused the email (${response.status}) : ${await response.text()}`,
      );
    }
  }
}
