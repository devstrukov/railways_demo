package ru.railways.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public record UpdateBookingRequest(
        Integer userId,

        @NotNull(message = "Статус обязателен")
        Integer statusId,

        @NotNull(message = "Сумма обязательна")
        @DecimalMin(value = "0", message = "Сумма не может быть отрицательной")
        @Digits(integer = 10, fraction = 2, message = "Сумма должна содержать не более двух знаков после запятой")
        BigDecimal totalAmount
) {
}
