package ru.railways.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.railways.dto.BookingStatusDto;
import ru.railways.repository.BookingRepository;

import java.util.List;

@RestController
@RequestMapping("/api/booking-statuses")
public class BookingStatusController {

    private final BookingRepository bookingRepository;

    public BookingStatusController(BookingRepository bookingRepository) {
        this.bookingRepository = bookingRepository;
    }

    @GetMapping
    public List<BookingStatusDto> getBookingStatuses() {
        return bookingRepository.findAllStatuses();
    }
}
