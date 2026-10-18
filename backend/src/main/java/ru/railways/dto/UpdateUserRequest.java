package ru.railways.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record UpdateUserRequest(
        @NotBlank(message = "ФИО обязательно")
        String fullName,

        @NotBlank(message = "Email обязателен")
        @Email(message = "Некорректный формат email")
        @Size(max = 255, message = "Email слишком длинный")
        String email,

        @Size(max = 20, message = "Телефон слишком длинный")
        String phoneNumber,

        @NotNull(message = "Роль обязательна")
        Integer roleId
) {
}
