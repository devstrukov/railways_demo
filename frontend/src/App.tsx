import { useEffect } from 'react';
import { closeReport, openBooking, openReport, setActiveTab } from './store/slices/uiSlice';
import { useAppDispatch, useAppSelector } from './store/hooks';
import UsersTab from './components/UsersTab';
import BookingsTab from './components/BookingsTab';
import BookingDetailTab from './components/BookingDetailTab';
import PrintReport from './components/PrintReport';
import type { TabId } from './types/models';

export default function App() {
  const dispatch = useAppDispatch();
  const { activeTab, selectedBookingId, showReport } = useAppSelector((state) => state.ui);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    if (showReport && selectedBookingId) {
      params.set('report', '1');
      params.set('bookingId', String(selectedBookingId));
    } else {
      params.delete('report');
      params.delete('bookingId');
    }
    const query = params.toString();
    const nextUrl = query ? `${window.location.pathname}?${query}` : window.location.pathname;
    window.history.replaceState(null, '', nextUrl);
  }, [showReport, selectedBookingId]);

  if (showReport && selectedBookingId) {
    return (
      <PrintReport
        bookingId={selectedBookingId}
        onBack={() => dispatch(closeReport())}
      />
    );
  }

  return (
    <div className="container py-4">
      <h1 className="mb-4">Железнодорожный агрегатор</h1>

      <ul className="nav nav-tabs mb-4 no-print">
        {(['users', 'bookings', 'detail'] as TabId[]).map((tab) => (
          <li key={tab} className="nav-item">
            <button
              type="button"
              className={`nav-link ${activeTab === tab ? 'active' : ''}`}
              onClick={() => dispatch(setActiveTab(tab))}
            >
              {tab === 'users' && 'Пользователи'}
              {tab === 'bookings' && 'Бронирования'}
              {tab === 'detail' && 'Подробное бронирование'}
            </button>
          </li>
        ))}
      </ul>

      {activeTab === 'users' && <UsersTab />}
      {activeTab === 'bookings' && (
        <BookingsTab onOpen={(bookingId) => dispatch(openBooking(bookingId))} />
      )}
      {activeTab === 'detail' && (
        <BookingDetailTab
          onOpenReport={(bookingId) => dispatch(openReport(bookingId))}
        />
      )}
    </div>
  );
}
