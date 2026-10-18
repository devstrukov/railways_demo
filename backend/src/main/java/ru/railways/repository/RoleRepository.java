package ru.railways.repository;

import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;
import ru.railways.dto.RoleDto;

import java.util.List;

@Repository
public class RoleRepository {

    private final NamedParameterJdbcTemplate jdbc;

    public RoleRepository(NamedParameterJdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<RoleDto> findAll() {
        return jdbc.query(
                "SELECT id, name FROM role ORDER BY id",
                (rs, rowNum) -> new RoleDto(rs.getInt("id"), rs.getString("name"))
        );
    }
}
