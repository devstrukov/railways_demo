package ru.railways.dto;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;

public record BookingDetailDto(
        Integer id,
        Integer userId,
        String userName,
        Integer statusId,
        String statusName,
        BigDecimal totalAmount,
        OffsetDateTime bookingTime,
        List<TicketDto> tickets
) {
}
