package dao;

import model.*;
import utils.DBConnection;
// Không cần import IConstant chứa formatter nữa (trừ khi dùng ở nơi khác)

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public ArrayList<Booking> getAllBookings() {
        ArrayList<Booking> result = new ArrayList<>();
        String sql = "SELECT TOP (1000) [BookingID], [GuestID], [RoomID], [CheckInDate], [CheckOutDate], [BookingDate], [Status] FROM [HotelManagement].[dbo].[BOOKING]";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs != null) {
                while (rs.next()) {
                    // Bước 1: Lấy tất cả dữ liệu từ ResultSet
                    int bookingId = rs.getInt("BookingID");
                    int guestId = rs.getInt("GuestID");
                    int roomId = rs.getInt("RoomID");
                    String status = rs.getString("Status");

                    // Lấy thẳng đối tượng ngày gi�?
                    LocalDateTime checkInDate = rs.getObject("CheckInDate", LocalDateTime.class);
                    LocalDateTime checkOutDate = rs.getObject("CheckOutDate", LocalDateTime.class);
                    LocalDate bookingDate = rs.getObject("BookingDate", LocalDate.class);

                    // Bước 2: Tạo đối tượng Booking và set trực tiếp các đối tượng ngày gi�?
                    Booking booking = new Booking();
                    booking.setBookingId(bookingId);
                    booking.setGuestId(guestId);
                    booking.setRoomId(roomId);
                    booking.setStatus(status);
                    booking.setCheckInDate(checkInDate);   // Gán trực tiếp đối tượng
                    booking.setCheckOutDate(checkOutDate); // Gán trực tiếp đối tượng
                    booking.setBookingDate(bookingDate);   // Gán trực tiếp đối tượng

                    result.add(booking);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public boolean addBooking(Booking booking) {
        boolean result = false;
        String sql = "INSERT INTO [dbo].[BOOKING] (GuestID, RoomID, CheckInDate, CheckOutDate, BookingDate, Status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, booking.getGuestId());
            ps.setInt(2, booking.getRoomId());
            ps.setObject(3, booking.getCheckInDate());   // Gán trực tiếp đối tượng
            ps.setObject(4, booking.getCheckOutDate()); // Gán trực tiếp đối tượng
            ps.setObject(5, booking.getBookingDate());   // Gán trực tiếp đối tượng
            ps.setString(6, booking.getStatus());

            result = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public int addBookingV2(Booking booking) {
        int generatedBookingId = -1; // Sẽ chứa ID trả v�?, mặc định là -1 (thất bại)
        String sql = "INSERT INTO [dbo].[BOOKING] (GuestID, RoomID, CheckInDate, CheckOutDate, BookingDate, Status) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             // BƯỚC 1: Yêu cầu JDBC trả v�? các key (ID) được tự động sinh ra
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, booking.getGuestId());
            ps.setInt(2, booking.getRoomId());
            ps.setObject(3, booking.getCheckInDate());
            ps.setObject(4, booking.getCheckOutDate());
            ps.setObject(5, booking.getBookingDate());
            ps.setString(6, booking.getStatus());

            int rowsAffected = ps.executeUpdate();

            // BƯỚC 2: Nếu insert thành công, tiến hành lấy ID
            if (rowsAffected > 0) {
                // Lấy v�? một ResultSet chứa các ID vừa được sinh ra
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    // Di chuyển đến dòng đầu tiên và lấy ID
                    if (rs.next()) {
                        // Lấy giá trị int từ cột đầu tiên, đó chính là BookingID
                        generatedBookingId = rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi, hàm sẽ trả v�? giá trị mặc định là -1
        }

        // BƯỚC 3: Trả v�? ID đã lấy được
        return generatedBookingId;
    }

    public Booking getBookingById(int bookingId) {
        Booking result = null;
        String sql = "SELECT [BookingID], [GuestID], [RoomID], [CheckInDate], [CheckOutDate], [BookingDate], [Status] FROM [HotelManagement].[dbo].[BOOKING] where BookingID = ?";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            if (rs != null) {
                while (rs.next()) {
                    // Bước 1: Lấy tất cả dữ liệu từ ResultSet

                    int guestId = rs.getInt("GuestID");
                    int roomId = rs.getInt("RoomID");
                    String status = rs.getString("Status");

                    // Lấy thẳng đối tượng ngày gi�?
                    LocalDateTime checkInDate = rs.getObject("CheckInDate", LocalDateTime.class);
                    LocalDateTime checkOutDate = rs.getObject("CheckOutDate", LocalDateTime.class);
                    LocalDate bookingDate = rs.getObject("BookingDate", LocalDate.class);

                    result = new Booking(bookingId, guestId, roomId, checkInDate, checkOutDate, bookingDate, status);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
    public Booking getBookingByRoomID(int roomID,LocalDate dateNow) {
        Booking result = null;
        String sql = "SELECT [BookingID], [GuestID], [RoomID], [CheckInDate], [CheckOutDate], [BookingDate], [Status] FROM [HotelManagement].[dbo].[BOOKING] where [RoomID] = ? and CheckInDate <= ?  AND Status Like N'Checked-in'; ";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, roomID);
            ps.setObject(2, dateNow);
            ResultSet rs = ps.executeQuery();

            if (rs != null) {
                while (rs.next()) {
                    
                    int bookingId = rs.getInt("BookingID");
                    int guestId = rs.getInt("GuestID");
                    int roomId = rs.getInt("RoomID");
                    String status = rs.getString("Status");
                    LocalDateTime checkInDate = rs.getObject("CheckInDate", LocalDateTime.class);
                    LocalDateTime checkOutDate = rs.getObject("CheckOutDate", LocalDateTime.class);
                    LocalDate bookingDate = rs.getObject("BookingDate", LocalDate.class);

                    result = new Booking(bookingId, guestId, roomId, checkInDate, checkOutDate, bookingDate, status);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public ArrayList<Booking> getBookingByGuestId(int guestId) {
        ArrayList<Booking> result = new ArrayList<>();
        String sql = "SELECT [BookingID], [GuestID], [RoomID], [CheckInDate], [CheckOutDate], [BookingDate], [Status] FROM [HotelManagement].[dbo].[BOOKING] where GuestID = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, guestId);
            rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    int bookingId = rs.getInt("BookingID");
                    int roomId = rs.getInt("RoomID");
                    String status = rs.getString("Status");
                    LocalDateTime checkInDate = rs.getObject("CheckInDate", LocalDateTime.class);
                    LocalDateTime checkOutDate = rs.getObject("CheckOutDate", LocalDateTime.class);
                    LocalDate bookingDate = rs.getObject("BookingDate", LocalDate.class);
                    Booking booking = new Booking();
                    booking.setBookingId(bookingId);
                    booking.setGuestId(guestId);
                    booking.setRoomId(roomId);
                    booking.setStatus(status);
                    booking.setCheckInDate(checkInDate);
                    booking.setCheckOutDate(checkOutDate);
                    booking.setBookingDate(bookingDate);

                    result.add(booking);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return result;
    }

    public ArrayList<Booking> getBookingByCheckInCheckOutDate(LocalDateTime checkInDate, LocalDateTime checkOutDate) {
        ArrayList<Booking> result = new ArrayList<>();

        String sql = "SELECT [BookingID], [GuestID], [RoomID], [CheckInDate], [CheckOutDate], [BookingDate], [Status] FROM [HotelManagement].[dbo].[BOOKING]";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {

            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    int bookingId = rs.getInt("BookingID");
                    int guestId = rs.getInt("GuestID");
                    int roomId = rs.getInt("RoomID");
                    String status = rs.getString("Status");
                    LocalDateTime dbCheckInDate = rs.getObject("CheckInDate", LocalDateTime.class);
                    LocalDateTime dbCheckOutDate = rs.getObject("CheckOutDate", LocalDateTime.class);
                    LocalDate bookingDate = rs.getObject("BookingDate", LocalDate.class);

                    // Kiểm tra đi�?u kiện ngày
                    if (dbCheckInDate.isBefore(checkOutDate) && dbCheckOutDate.isAfter(checkInDate)) {
                        Booking booking = new Booking();
                        booking.setBookingId(bookingId);
                        booking.setGuestId(guestId);
                        booking.setRoomId(roomId);
                        booking.setStatus(status);
                        booking.setCheckInDate(dbCheckInDate);
                        booking.setCheckOutDate(dbCheckOutDate);
                        booking.setBookingDate(bookingDate);

                        result.add(booking);
                    }
                }
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        ArrayList<Booking> result2 = new ArrayList<>();
        List<LocalDate> datesInRange = new ArrayList<>();

        LocalDate currentDate = checkInDate.toLocalDate();

        LocalDate endDate = checkOutDate.toLocalDate();

        while (!currentDate.isAfter(endDate)) {
            // Thêm ngày hiện tại vào danh sách
            datesInRange.add(currentDate);

            // Tăng ngày hiện tại lên 1 ngày để chuẩn bị cho vòng lặp tiếp theo
            currentDate = currentDate.plusDays(1);
        }

        for (Booking booking : result) {
            LocalDate bookingCheckInDate = booking.getCheckInDate().toLocalDate();
            LocalDate bookingCheckOutDate = booking.getCheckOutDate().toLocalDate();

            for (LocalDate date : datesInRange) {
                if ((date.isEqual(bookingCheckInDate) || date.isAfter(bookingCheckInDate)) &&
                        (date.isEqual(bookingCheckOutDate) || date.isBefore(bookingCheckOutDate))) {
                    result2.add(booking);
                    break; // Không cần kiểm tra các ngày còn lại, đã tìm thấy ngày phù hợp
                }
            }

        }
        return result2;
    }

    public int countCurrCheckedInRooms(String str) {
        int result = 0;
        System.out.println("status param = [" + str + "]");
        String sql = "SELECT COUNT(*) as total \n"
                + "FROM [HotelManagement].[dbo].[BOOKING]\n"
                + "WHERE [Status] = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, str);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                result = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public ArrayList<BookingActionRow> getBookingByStatus(String status, String orderByCheck) {
        ArrayList<BookingActionRow> result = new ArrayList<>();

        switch (orderByCheck == null ? "" : orderByCheck.toLowerCase()) {
            case "checkout":
                orderByCheck = "b.CheckOutDate";
                break;
            case "booking":
                orderByCheck = "b.BookingDate";
                break;
            case "checkin":
                orderByCheck = "b.CheckInDate";
                break;
        }

        String sql = "SELECT b.BookingID,b.RoomID,b.CheckInDate,b.CheckOutDate,\n"
                + "       g.FullName,g.Email,g.Phone,\n"
                + "       r.RoomNumber,rt.TypeName\n"
                + "FROM BOOKING b JOIN GUEST g ON g.GuestID=b.GuestID JOIN ROOM  r ON r.RoomID=b.RoomID\n"
                + "JOIN ROOM_TYPE rt ON rt.RoomTypeID=r.RoomTypeID\n"
                + "WHERE b.Status = ?\n"
                + "ORDER BY " + orderByCheck;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, status);
            rs = ps.executeQuery();
            if (rs != null) {
                while (rs.next()) {

                    int bookingId = rs.getInt("BookingID");
                    int roomId = rs.getInt("RoomID");
                    LocalDateTime checkInDate = rs.getObject("CheckInDate", LocalDateTime.class);
                    LocalDateTime checkOutDate = rs.getObject("CheckOutDate", LocalDateTime.class);
                    String fullname = rs.getString("FullName");
                    String email = rs.getString("Email");
                    String phone = rs.getString("Phone");
                    String roomNum = rs.getString("RoomNumber");
                    String roomType = rs.getString("TypeName");

                    Room r = new Room(roomNum);
                    Booking b = new Booking(bookingId, roomId, checkInDate, checkOutDate);
                    Guest g = new Guest(fullname, phone, email);
                    RoomType t = new RoomType(roomType);

                    BookingActionRow booking = new BookingActionRow(b, r, g, t);
                    result.add(booking);
                }
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return result;
    }

    public boolean updateBookingStatus(int bookingId, String status) {
        boolean result = false;

        String sql = "UPDATE [dbo].[BOOKING] SET Status = ? WHERE [BookingID] = ? ";
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            result = ps.executeUpdate() > 0;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return result;
    }
}