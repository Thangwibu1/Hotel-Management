package listener;

import controller.feature.EmailSender;
import controller.feature.EnvConfig;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class StartupEmailListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            System.out.println("INFO: Server is starting, attempting to send startup email.");

            String toEmail = EnvConfig.get("EMAIL_TO");

            if (toEmail == null || toEmail.trim().isEmpty()) {
                System.err.println("ERROR: MAIL_TO environment variable is not set. Cannot send startup email.");
                return;
            }

            EmailSender emailSender = new EmailSender();

            String subject = "Server Startup Notification";
            String body = "The Hotel Management application server has started successfully.";
            boolean success = emailSender.sendTextEmail(toEmail, subject, body);

            if (success) {
                System.out.println("INFO: Startup email sent successfully to " + toEmail);
            } else {
                System.err.println("ERROR: Failed to send startup email.");
            }

        } catch (Exception e) {
            System.err.println("ERROR: An unexpected error occurred in StartupEmailListener during startup.");
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            System.out.println("INFO: Server is shutting down, attempting to send shutdown email.");

            String toEmail = EnvConfig.get("MAIL_TO");

            if (toEmail == null || toEmail.trim().isEmpty()) {
                System.err.println("ERROR: MAIL_TO environment variable is not set. Cannot send shutdown email.");
                return;
            }

            EmailSender emailSender = new EmailSender();

            String subject = "Server Shutdown Notification";
            String body = "The Hotel Management application server has been shut down.";
            boolean success = emailSender.sendTextEmail(toEmail, subject, body);

            if (success) {
                System.out.println("INFO: Shutdown email sent successfully to " + toEmail);
            } else {
                System.err.println("ERROR: Failed to send shutdown email.");
            }

        } catch (Exception e) {
            System.err.println("ERROR: An unexpected error occurred during server shutdown email notification.");
            e.printStackTrace();
        }
    }
}