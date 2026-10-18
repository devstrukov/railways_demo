import { configureStore } from '@reduxjs/toolkit';
import uiReducer from './slices/uiSlice';
import usersReducer from './slices/usersSlice';
import bookingsReducer from './slices/bookingsSlice';
import bookingDetailReducer from './slices/bookingDetailSlice';

export const store = configureStore({
  reducer: {
    ui: uiReducer,
    users: usersReducer,
    bookings: bookingsReducer,
    bookingDetail: bookingDetailReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
