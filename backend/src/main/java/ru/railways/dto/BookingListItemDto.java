package ru.railways.dto;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

public record BookingListItemDto(
        Integer id,
        Integer userId,
        String userName,
        Integer statusId,
        String statusName,
        BigDecimal totalAmount,
        OffsetDateTime bookingTime
) {
}
