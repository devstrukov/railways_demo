package ru.railways.controller;

import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.railways.dto.UpdateUserRequest;
import ru.railways.dto.UserDto;
import ru.railways.repository.UserRepository;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping
    public List<UserDto> getUsers() {
        return userRepository.findAll();
    }

    @PutMapping("/{id}")
    public UserDto updateUser(@PathVariable int id, @Valid @RequestBody UpdateUserRequest request) {
        return userRepository.update(id, request);
    }
}
