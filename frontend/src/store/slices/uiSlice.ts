import { createSlice, type PayloadAction } from '@reduxjs/toolkit';
import type { TabId } from '../../types/models';

interface UiState {
  activeTab: TabId;
  selectedBookingId: number | null;
  showReport: boolean;
}

function getInitialUiState(): UiState {
  const params = new URLSearchParams(window.location.search);
  const report = params.get('report');
  const bookingId = params.get('bookingId');

  if (report === '1' && bookingId) {
    return {
      activeTab: 'detail',
      selectedBookingId: Number(bookingId),
      showReport: true,
    };
  }

  return {
    activeTab: 'users',
    selectedBookingId: null,
    showReport: false,
  };
}

const uiSlice = createSlice({
  name: 'ui',
  initialState: getInitialUiState(),
  reducers: {
    setActiveTab(state, action: PayloadAction<TabId>) {
      state.activeTab = action.payload;
    },
    selectBooking(state, action: PayloadAction<number>) {
      state.selectedBookingId = action.payload;
    },
    openBooking(state, action: PayloadAction<number>) {
      state.selectedBookingId = action.payload;
      state.activeTab = 'detail';
      state.showReport = false;
    },
    openReport(state, action: PayloadAction<number>) {
      state.selectedBookingId = action.payload;
      state.showReport = true;
    },
    closeReport(state) {
      state.showReport = false;
    },
  },
});

export const { setActiveTab, selectBooking, openBooking, openReport, closeReport } = uiSlice.actions;
export default uiSlice.reducer;
