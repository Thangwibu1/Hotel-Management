package controller.feature;

import javax.mail.*;
import javax.mail.internet.*;
import java.io.File;
import java.util.List;
import java.util.Properties;
public class EmailSender {

    private final String fromEmail;
    private final String appPassword;
    private final String smtpHost;
    private final int smtpPort;
    private final Session session;

    /**
     * Constructor - Load cấu hình từ file .env
     */
    public EmailSender() {
        // Load thông tin từ .env
        this.fromEmail = EnvConfig.getRequired("EMAIL_FROM");
        this.appPassword = EnvConfig.getRequired("EMAIL_PASSWORD");
        this.smtpHost = EnvConfig.get("SMTP_HOST", "smtp.gmail.com");
        this.smtpPort = EnvConfig.getInt("SMTP_PORT", 587);

        // Tạo session
        this.session = createSession();

        System.out.println("✓ EmailSender đã được khởi tạo thành công!");
        System.out.println("  From: " + fromEmail);
        System.out.println("  SMTP: " + smtpHost + ":" + smtpPort);
    }

    /**
     * Constructor với tham số tùy chỉnh
     */
    public EmailSender(String fromEmail, String appPassword, String smtpHost, int smtpPort) {
        this.fromEmail = fromEmail;
        this.appPassword = appPassword;
        this.smtpHost = smtpHost;
        this.smtpPort = smtpPort;
        this.session = createSession();
    }

    /**
     * Tạo Mail Session với authentication
     */
    private Session createSession() {
        Properties props = new Properties();
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", String.valueOf(smtpPort));
        props.put("mail.smtp.auth", "true");
        
        // Nếu port 465, dùng SSL, nếu port 587 dùng STARTTLS
        if (smtpPort == 465) {
            // SSL Mode (Port 465)
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
            props.put("mail.smtp.ssl.trust", smtpHost);
        } else {
            // STARTTLS Mode (Port 587)
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
            props.put("mail.smtp.ssl.trust", smtpHost);
        }
        
        // Timeout settings
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");
        
        // Debug mode (có thể b�? comment để debug)
        // props.put("mail.debug", "true");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, appPassword);
            }
        });
    }

    /**
     * Gửi email văn bản đơn giản
     *
     * @param toEmail Email ngư�?i nhận
     * @param subject Tiêu đ�? email
     * @param body    Nội dung email
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public boolean sendTextEmail(String toEmail, String subject, String body) {
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
            System.out.println("✓ Email đã được gửi thành công đến: " + toEmail);
            return true;

        } catch (MessagingException e) {
            System.err.println("✗ Lỗi khi gửi email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gửi email với nội dung HTML
     *
     * @param toEmail  Email ngư�?i nhận
     * @param subject  Tiêu đ�? email
     * @param htmlBody Nội dung HTML
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public boolean sendHtmlEmail(String toEmail, String subject, String htmlBody) {
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("✓ Email HTML đã được gửi thành công đến: " + toEmail);
            return true;

        } catch (MessagingException e) {
            System.err.println("✗ Lỗi khi gửi email HTML: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gửi email với file đính kèm
     *
     * @param toEmail  Email ngư�?i nhận
     * @param subject  Tiêu đ�? email
     * @param body     Nội dung email
     * @param filePath �?ư�?ng dẫn đến file đính kèm
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public boolean sendEmailWithAttachment(String toEmail, String subject, String body, String filePath) {
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);

            // Tạo phần nội dung
            BodyPart messageBodyPart = new MimeBodyPart();
            messageBodyPart.setText(body);

            // Tạo multipart
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);

            // Thêm file đính kèm
            messageBodyPart = new MimeBodyPart();
            File file = new File(filePath);
            if (!file.exists()) {
                System.err.println("✗ File không tồn tại: " + filePath);
                return false;
            }
            ((MimeBodyPart) messageBodyPart).attachFile(file);
            multipart.addBodyPart(messageBodyPart);

            message.setContent(multipart);

            Transport.send(message);
            System.out.println("✓ Email với file đính kèm đã được gửi thành công đến: " + toEmail);
            return true;

        } catch (Exception e) {
            System.err.println("✗ Lỗi khi gửi email với file đính kèm: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gửi email với nhi�?u file đính kèm
     *
     * @param toEmail   Email ngư�?i nhận
     * @param subject   Tiêu đ�? email
     * @param body      Nội dung email
     * @param filePaths Danh sách đư�?ng dẫn các file đính kèm
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public boolean sendEmailWithMultipleAttachments(String toEmail, String subject, String body, List<String> filePaths) {
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);

            // Tạo phần nội dung
            BodyPart messageBodyPart = new MimeBodyPart();
            messageBodyPart.setText(body);

            // Tạo multipart
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);

            // Thêm các file đính kèm
            for (String filePath : filePaths) {
                File file = new File(filePath);
                if (!file.exists()) {
                    System.err.println("⚠ Cảnh báo: File không tồn tại, b�? qua: " + filePath);
                    continue;
                }
                messageBodyPart = new MimeBodyPart();
                ((MimeBodyPart) messageBodyPart).attachFile(file);
                multipart.addBodyPart(messageBodyPart);
            }

            message.setContent(multipart);

            Transport.send(message);
            System.out.println("✓ Email với nhi�?u file đính kèm đã được gửi thành công đến: " + toEmail);
            return true;

        } catch (Exception e) {
            System.err.println("✗ Lỗi khi gửi email với nhi�?u file đính kèm: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gửi email đến nhi�?u ngư�?i nhận
     *
     * @param toEmails Danh sách email ngư�?i nhận
     * @param subject  Tiêu đ�? email
     * @param body     Nội dung email
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public boolean sendEmailToMultipleRecipients(List<String> toEmails, String subject, String body) {
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));

            // Tạo danh sách địa chỉ ngư�?i nhận
            InternetAddress[] addresses = new InternetAddress[toEmails.size()];
            for (int i = 0; i < toEmails.size(); i++) {
                addresses[i] = new InternetAddress(toEmails.get(i));
            }
            message.setRecipients(Message.RecipientType.TO, addresses);

            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
            System.out.println("✓ Email đã được gửi thành công đến " + toEmails.size() + " ngư�?i nhận");
            return true;

        } catch (MessagingException e) {
            System.err.println("✗ Lỗi khi gửi email đến nhi�?u ngư�?i nhận: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gửi email với CC và BCC
     *
     * @param toEmail   Email ngư�?i nhận chính
     * @param ccEmails  Danh sách email CC (có thể null)
     * @param bccEmails Danh sách email BCC (có thể null)
     * @param subject   Tiêu đ�? email
     * @param body      Nội dung email
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public boolean sendEmailWithCcBcc(String toEmail, List<String> ccEmails, List<String> bccEmails,
                                      String subject, String body) {
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));

            // Thêm CC
            if (ccEmails != null && !ccEmails.isEmpty()) {
                InternetAddress[] ccAddresses = new InternetAddress[ccEmails.size()];
                for (int i = 0; i < ccEmails.size(); i++) {
                    ccAddresses[i] = new InternetAddress(ccEmails.get(i));
                }
                message.setRecipients(Message.RecipientType.CC, ccAddresses);
            }

            // Thêm BCC
            if (bccEmails != null && !bccEmails.isEmpty()) {
                InternetAddress[] bccAddresses = new InternetAddress[bccEmails.size()];
                for (int i = 0; i < bccEmails.size(); i++) {
                    bccAddresses[i] = new InternetAddress(bccEmails.get(i));
                }
                message.setRecipients(Message.RecipientType.BCC, bccAddresses);
            }

            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
            System.out.println("✓ Email với CC/BCC đã được gửi thành công");
            return true;

        } catch (MessagingException e) {
            System.err.println("✗ Lỗi khi gửi email với CC/BCC: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
