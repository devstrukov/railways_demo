package ru.railways.repository;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;
import ru.railways.dto.UpdateUserRequest;
import ru.railways.dto.UserDto;
import ru.railways.exception.ApiException;

import java.util.List;
import java.util.Optional;

@Repository
public class UserRepository {

    private final NamedParameterJdbcTemplate jdbc;

    public UserRepository(NamedParameterJdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<UserDto> findAll() {
        String sql = """
                SELECT u.id, u.full_name, u.email, u.phone_number, u.role, r.name AS role_name
                FROM users u
                JOIN role r ON u.role = r.id
                ORDER BY u.id
                """;
        return jdbc.query(sql, (rs, rowNum) -> new UserDto(
                rs.getInt("id"),
                rs.getString("full_name"),
                rs.getString("email"),
                rs.getString("phone_number"),
                rs.getInt("role"),
                rs.getString("role_name")
        ));
    }

    public Optional<UserDto> findById(int id) {
        String sql = """
                SELECT u.id, u.full_name, u.email, u.phone_number, u.role, r.name AS role_name
                FROM users u
                JOIN role r ON u.role = r.id
                WHERE u.id = :id
                """;
        try {
            UserDto user = jdbc.queryForObject(sql, new MapSqlParameterSource("id", id), (rs, rowNum) -> new UserDto(
                    rs.getInt("id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("phone_number"),
                    rs.getInt("role"),
                    rs.getString("role_name")
            ));
            return Optional.ofNullable(user);
        } catch (EmptyResultDataAccessException ex) {
            return Optional.empty();
        }
    }

    public UserDto update(int id, UpdateUserRequest request) {
        if (!roleExists(request.roleId())) {
            throw new ApiException(400, "Указанная роль не существует");
        }

        String sql = """
                UPDATE users
                SET full_name = :fullName,
                    email = :email,
                    phone_number = :phoneNumber,
                    role = :roleId,
                    updated_at = now()
                WHERE id = :id
                """;

        int updated = jdbc.update(sql, new MapSqlParameterSource()
                .addValue("id", id)
                .addValue("fullName", request.fullName())
                .addValue("email", request.email())
                .addValue("phoneNumber", request.phoneNumber())
                .addValue("roleId", request.roleId()));

        if (updated == 0) {
            throw new ApiException(404, "Пользователь не найден");
        }

        return findById(id).orElseThrow(() -> new ApiException(404, "Пользователь не найден"));
    }

    private boolean roleExists(int roleId) {
        Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM role WHERE id = :id",
                new MapSqlParameterSource("id", roleId),
                Integer.class
        );
        return count != null && count > 0;
    }
}
