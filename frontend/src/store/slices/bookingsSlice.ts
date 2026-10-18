import { createAsyncThunk, createSlice } from '@reduxjs/toolkit';
import type { BookingListItem } from '../../types/models';
import { api } from '../../utils/api';

interface BookingsState {
  items: BookingListItem[];
  loading: boolean;
  error: string | null;
}

const initialState: BookingsState = {
  items: [],
  loading: false,
  error: null,
};

export const fetchBookings = createAsyncThunk('bookings/fetchBookings', async () => {
  return api.getBookings();
});

const bookingsSlice = createSlice({
  name: 'bookings',
  initialState,
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(fetchBookings.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchBookings.fulfilled, (state, action) => {
        state.loading = false;
        state.items = action.payload;
      })
      .addCase(fetchBookings.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message ?? 'Ошибка загрузки бронирований';
      });
  },
});

export default bookingsSlice.reducer;
