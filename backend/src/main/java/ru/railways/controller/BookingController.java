package ru.railways.controller;

import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.railways.dto.BookingDetailDto;
import ru.railways.dto.BookingListItemDto;
import ru.railways.dto.UpdateBookingRequest;
import ru.railways.exception.ApiException;
import ru.railways.repository.BookingRepository;

import java.util.List;

@RestController
@RequestMapping("/api/bookings")
public class BookingController {

    private final BookingRepository bookingRepository;

    public BookingController(BookingRepository bookingRepository) {
        this.bookingRepository = bookingRepository;
    }

    @GetMapping
    public List<BookingListItemDto> getBookings() {
        return bookingRepository.findAll();
    }

    @GetMapping("/{id}")
    public BookingDetailDto getBooking(@PathVariable int id) {
        return bookingRepository.findById(id)
                .orElseThrow(() -> new ApiException(404, "Бронирование не найдено"));
    }

    @PutMapping("/{id}")
    public BookingDetailDto updateBooking(@PathVariable int id, @Valid @RequestBody UpdateBookingRequest request) {
        return bookingRepository.update(id, request);
    }
}
