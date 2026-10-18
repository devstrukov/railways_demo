package ru.railways.repository;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;
import ru.railways.dto.BookingDetailDto;
import ru.railways.dto.BookingListItemDto;
import ru.railways.dto.BookingStatusDto;
import ru.railways.dto.TicketDto;
import ru.railways.dto.UpdateBookingRequest;
import ru.railways.exception.ApiException;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class BookingRepository {

    private final NamedParameterJdbcTemplate jdbc;

    public BookingRepository(NamedParameterJdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<BookingStatusDto> findAllStatuses() {
        return jdbc.query(
                "SELECT id, name FROM booking_status ORDER BY id",
                (rs, rowNum) -> new BookingStatusDto(rs.getInt("id"), rs.getString("name"))
        );
    }

    public List<BookingListItemDto> findAll() {
        String sql = """
                SELECT b.id, b.user_id, u.full_name AS user_name,
                       b.status_id, s.name AS status_name,
                       b.total_amount, b.booking_time
                FROM booking b
                JOIN booking_status s ON b.status_id = s.id
                LEFT JOIN users u ON b.user_id = u.id
                ORDER BY b.id
                """;
        return jdbc.query(sql, (rs, rowNum) -> mapListItem(rs));
    }

    public Optional<BookingDetailDto> findById(int id) {
        String sql = """
                SELECT b.id, b.user_id, u.full_name AS user_name,
                       b.status_id, s.name AS status_name,
                       b.total_amount, b.booking_time
                FROM booking b
                JOIN booking_status s ON b.status_id = s.id
                LEFT JOIN users u ON b.user_id = u.id
                WHERE b.id = :id
                """;
        try {
            BookingDetailDto booking = jdbc.queryForObject(sql, new MapSqlParameterSource("id", id), (rs, rowNum) -> {
                BookingListItemDto item = mapListItem(rs);
                return new BookingDetailDto(
                        item.id(),
                        item.userId(),
                        item.userName(),
                        item.statusId(),
                        item.statusName(),
                        item.totalAmount(),
                        item.bookingTime(),
                        List.of()
                );
            });
            if (booking == null) {
                return Optional.empty();
            }
            List<TicketDto> tickets = findTicketsByBookingId(id);
            return Optional.of(new BookingDetailDto(
                    booking.id(),
                    booking.userId(),
                    booking.userName(),
                    booking.statusId(),
                    booking.statusName(),
                    booking.totalAmount(),
                    booking.bookingTime(),
                    tickets
            ));
        } catch (EmptyResultDataAccessException ex) {
            return Optional.empty();
        }
    }

    public BookingDetailDto update(int id, UpdateBookingRequest request) {
        if (request.userId() != null && !userExists(request.userId())) {
            throw new ApiException(400, "Указанный пользователь не существует");
        }
        if (!statusExists(request.statusId())) {
            throw new ApiException(400, "Указанный статус не существует");
        }

        String sql = """
                UPDATE booking
                SET user_id = :userId,
                    status_id = :statusId,
                    total_amount = :totalAmount
                WHERE id = :id
                """;

        int updated = jdbc.update(sql, new MapSqlParameterSource()
                .addValue("id", id)
                .addValue("userId", request.userId())
                .addValue("statusId", request.statusId())
                .addValue("totalAmount", request.totalAmount()));

        if (updated == 0) {
            throw new ApiException(404, "Бронирование не найдено");
        }

        return findById(id).orElseThrow(() -> new ApiException(404, "Бронирование не найдено"));
    }

    private List<TicketDto> findTicketsByBookingId(int bookingId) {
        String sql = """
                SELECT t.id, u.full_name AS user_name, o.name AS operator_name
                FROM ticket t
                JOIN users u ON t.user_id = u.id
                JOIN train_operator o ON t.provider_id = o.id
                WHERE t.booking_id = :bookingId
                ORDER BY t.id
                """;
        return jdbc.query(sql, new MapSqlParameterSource("bookingId", bookingId),
                (rs, rowNum) -> new TicketDto(
                        rs.getInt("id"),
                        rs.getString("user_name"),
                        rs.getString("operator_name")
                ));
    }

    private BookingListItemDto mapListItem(ResultSet rs) throws SQLException {
        Integer userId = rs.getObject("user_id") != null ? rs.getInt("user_id") : null;
        String userName = rs.getString("user_name");
        return new BookingListItemDto(
                rs.getInt("id"),
                userId,
                userName,
                rs.getInt("status_id"),
                rs.getString("status_name"),
                rs.getBigDecimal("total_amount"),
                rs.getObject("booking_time", OffsetDateTime.class)
        );
    }

    private boolean userExists(int userId) {
        Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM users WHERE id = :id",
                new MapSqlParameterSource("id", userId),
                Integer.class
        );
        return count != null && count > 0;
    }

    private boolean statusExists(int statusId) {
        Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM booking_status WHERE id = :id",
                new MapSqlParameterSource("id", statusId),
                Integer.class
        );
        return count != null && count > 0;
    }
}
