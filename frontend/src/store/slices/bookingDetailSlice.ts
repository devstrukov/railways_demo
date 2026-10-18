import { createAsyncThunk, createSlice, type PayloadAction } from '@reduxjs/toolkit';
import type {
  BookingDetail,
  BookingDraft,
  BookingListItem,
  BookingStatus,
  User,
} from '../../types/models';
import { api } from '../../utils/api';
import { createBookingDraft } from '../../utils/drafts';

interface BookingDetailState {
  bookings: BookingListItem[];
  users: User[];
  statuses: BookingStatus[];
  booking: BookingDetail | null;
  draft: BookingDraft | null;
  savedDraft: BookingDraft | null;
  loading: boolean;
  loadingDetail: boolean;
  saving: boolean;
  error: string | null;
  success: string | null;
  reportBooking: BookingDetail | null;
  reportLoading: boolean;
  reportError: string | null;
}

const initialState: BookingDetailState = {
  bookings: [],
  users: [],
  statuses: [],
  booking: null,
  draft: null,
  savedDraft: null,
  loading: false,
  loadingDetail: false,
  saving: false,
  error: null,
  success: null,
  reportBooking: null,
  reportLoading: false,
  reportError: null,
};

export const fetchDetailLists = createAsyncThunk('bookingDetail/fetchDetailLists', async () => {
  const [bookings, users, statuses] = await Promise.all([
    api.getBookings(),
    api.getUsers(),
    api.getBookingStatuses(),
  ]);
  return { bookings, users, statuses };
});

export const fetchBookingDetail = createAsyncThunk(
  'bookingDetail/fetchBookingDetail',
  async (bookingId: number) => api.getBooking(bookingId),
);

export const fetchReportBooking = createAsyncThunk(
  'bookingDetail/fetchReportBooking',
  async (bookingId: number) => api.getBooking(bookingId),
);

export const saveBookingDetail = createAsyncThunk(
  'bookingDetail/saveBookingDetail',
  async ({ bookingId, draft }: { bookingId: number; draft: BookingDraft }) => {
    const updated = await api.updateBooking(bookingId, {
      userId: draft.userId === '' ? null : Number(draft.userId),
      statusId: Number(draft.statusId),
      totalAmount: draft.totalAmount,
    });
    return updated;
  },
);

const bookingDetailSlice = createSlice({
  name: 'bookingDetail',
  initialState,
  reducers: {
    setDraftField(
      state,
      action: PayloadAction<{ field: keyof BookingDraft; value: string | number }>,
    ) {
      if (!state.draft) {
        return;
      }
      const { field, value } = action.payload;
      if (field === 'userId') {
        state.draft.userId = value === '' ? '' : Number(value);
      } else if (field === 'statusId') {
        state.draft.statusId = Number(value);
      } else {
        state.draft.totalAmount = String(value);
      }
      state.success = null;
    },
    resetDraft(state) {
      if (state.savedDraft) {
        state.draft = { ...state.savedDraft };
      }
      state.success = null;
    },
    clearBookingSuccess(state) {
      state.success = null;
    },
    clearReport(state) {
      state.reportBooking = null;
      state.reportLoading = false;
      state.reportError = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchDetailLists.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchDetailLists.fulfilled, (state, action) => {
        state.loading = false;
        state.bookings = action.payload.bookings;
        state.users = action.payload.users;
        state.statuses = action.payload.statuses;
      })
      .addCase(fetchDetailLists.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message ?? 'Ошибка загрузки данных';
      })
      .addCase(fetchBookingDetail.pending, (state) => {
        state.loadingDetail = true;
        state.error = null;
        state.success = null;
      })
      .addCase(fetchBookingDetail.fulfilled, (state, action) => {
        state.loadingDetail = false;
        const nextDraft = createBookingDraft(action.payload);
        state.booking = action.payload;
        state.draft = nextDraft;
        state.savedDraft = nextDraft;
      })
      .addCase(fetchBookingDetail.rejected, (state, action) => {
        state.loadingDetail = false;
        state.error = action.error.message ?? 'Ошибка загрузки бронирования';
        state.booking = null;
        state.draft = null;
        state.savedDraft = null;
      })
      .addCase(fetchReportBooking.pending, (state) => {
        state.reportLoading = true;
        state.reportError = null;
      })
      .addCase(fetchReportBooking.fulfilled, (state, action) => {
        state.reportLoading = false;
        state.reportBooking = action.payload;
      })
      .addCase(fetchReportBooking.rejected, (state, action) => {
        state.reportLoading = false;
        state.reportError = action.error.message ?? 'Ошибка загрузки отчёта';
      })
      .addCase(saveBookingDetail.pending, (state) => {
        state.saving = true;
        state.error = null;
        state.success = null;
      })
      .addCase(saveBookingDetail.fulfilled, (state, action) => {
        state.saving = false;
        const nextDraft = createBookingDraft(action.payload);
        state.booking = action.payload;
        state.draft = nextDraft;
        state.savedDraft = nextDraft;
        state.bookings = state.bookings.map((item) =>
          item.id === action.payload.id
            ? {
                id: action.payload.id,
                userId: action.payload.userId,
                userName: action.payload.userName,
                statusId: action.payload.statusId,
                statusName: action.payload.statusName,
                totalAmount: action.payload.totalAmount,
                bookingTime: action.payload.bookingTime,
              }
            : item,
        );
        state.success = 'Изменения сохранены';
      })
      .addCase(saveBookingDetail.rejected, (state, action) => {
        state.saving = false;
        state.error = action.error.message ?? 'Ошибка сохранения';
      });
  },
});

export const { setDraftField, resetDraft, clearBookingSuccess, clearReport } = bookingDetailSlice.actions;
export default bookingDetailSlice.reducer;
