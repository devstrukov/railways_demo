package ru.railways.dto;

public record UserDto(
        Integer id,
        String fullName,
        String email,
        String phoneNumber,
        Integer roleId,
        String roleName
) {
}
