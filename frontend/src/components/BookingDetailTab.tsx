import { useEffect, useMemo } from 'react';
import { useAppDispatch, useAppSelector } from '../store/hooks';
import { selectBooking } from '../store/slices/uiSlice';
import {
  fetchBookingDetail,
  fetchDetailLists,
  resetDraft,
  saveBookingDetail,
  setDraftField,
} from '../store/slices/bookingDetailSlice';
import { bookingDraftsEqual } from '../utils/drafts';
import { formatDate } from '../utils/format';

interface BookingDetailTabProps {
  onOpenReport: (bookingId: number) => void;
}

export default function BookingDetailTab({ onOpenReport }: BookingDetailTabProps) {
  const dispatch = useAppDispatch();
  const { selectedBookingId } = useAppSelector((state) => state.ui);
  const {
    bookings,
    users,
    statuses,
    booking,
    draft,
    savedDraft,
    loading,
    loadingDetail,
    saving,
    error,
    success,
  } = useAppSelector((state) => state.bookingDetail);

  const currentBookingId = selectedBookingId ?? (bookings[0]?.id ?? null);

  const bookingOptions = useMemo(
    () => bookings.map((item) => ({
      id: item.id,
      label: `№ ${item.id} — ${item.userName || 'Не указан'}`,
    })),
    [bookings],
  );

  useEffect(() => {
    dispatch(fetchDetailLists()).then((result) => {
      if (
        fetchDetailLists.fulfilled.match(result)
        && !selectedBookingId
        && result.payload.bookings.length > 0
      ) {
        dispatch(selectBooking(result.payload.bookings[0].id));
      }
    });
  }, [dispatch, selectedBookingId]);

  useEffect(() => {
    if (currentBookingId) {
      dispatch(fetchBookingDetail(currentBookingId));
    }
  }, [dispatch, currentBookingId]);

  const isDirty = draft && savedDraft && !bookingDraftsEqual(draft, savedDraft);

  const handleBookingChange = (nextId: string) => {
    const numericId = Number(nextId);
    if (numericId === currentBookingId) {
      return;
    }
    if (isDirty && !window.confirm('Есть несохранённые изменения. Продолжить без сохранения?')) {
      return;
    }
    dispatch(selectBooking(numericId));
  };

  const handleSave = () => {
    if (!booking || !draft) {
      return;
    }
    dispatch(saveBookingDetail({ bookingId: booking.id, draft }));
  };

  const handleOpenReport = () => {
    if (isDirty) {
      window.alert('Сначала сохраните или отмените несохранённые изменения.');
      return;
    }
    if (currentBookingId) {
      onOpenReport(currentBookingId);
    }
  };

  if (loading) {
    return <div className="alert alert-info">Загрузка данных...</div>;
  }

  if (bookings.length === 0) {
    return <div className="alert alert-secondary">Бронирования не найдены</div>;
  }

  return (
    <div>
      {error && <div className="alert alert-danger">{error}</div>}
      {success && <div className="alert alert-success">{success}</div>}

      <div className="mb-3">
        <label className="form-label" htmlFor="booking-select">Выбор бронирования</label>
        <select
          id="booking-select"
          className="form-select"
          value={currentBookingId ?? ''}
          onChange={(e) => handleBookingChange(e.target.value)}
        >
          {bookingOptions.map((option) => (
            <option key={option.id} value={option.id}>{option.label}</option>
          ))}
        </select>
      </div>

      {loadingDetail && <div className="alert alert-info">Загрузка бронирования...</div>}

      {!loadingDetail && booking && draft && (
        <>
          <div className="border rounded p-3 mb-4">
            <div className="row g-3">
              <div className="col-md-2">
                <label className="form-label">Номер</label>
                <input className="form-control" value={booking.id} readOnly />
              </div>
              <div className="col-md-3">
                <label className="form-label" htmlFor="booking-user">Пользователь</label>
                <select
                  id="booking-user"
                  className="form-select"
                  value={draft.userId}
                  onChange={(e) => dispatch(setDraftField({ field: 'userId', value: e.target.value }))}
                >
                  <option value="">Не указан</option>
                  {users.map((user) => (
                    <option key={user.id} value={user.id}>{user.fullName}</option>
                  ))}
                </select>
              </div>
              <div className="col-md-3">
                <label className="form-label" htmlFor="booking-status">Статус</label>
                <select
                  id="booking-status"
                  className="form-select"
                  value={draft.statusId}
                  onChange={(e) => dispatch(setDraftField({ field: 'statusId', value: e.target.value }))}
                >
                  {statuses.map((status) => (
                    <option key={status.id} value={status.id}>{status.name}</option>
                  ))}
                </select>
              </div>
              <div className="col-md-2">
                <label className="form-label" htmlFor="booking-amount">Сумма</label>
                <input
                  id="booking-amount"
                  className="form-control"
                  value={draft.totalAmount}
                  onChange={(e) => dispatch(setDraftField({ field: 'totalAmount', value: e.target.value }))}
                />
              </div>
              <div className="col-md-2">
                <label className="form-label">Дата бронирования</label>
                <input className="form-control" value={formatDate(booking.bookingTime)} readOnly />
              </div>
            </div>

            <div className="d-flex gap-2 mt-3 no-print">
              <button type="button" className="btn btn-primary" disabled={saving} onClick={handleSave}>
                Сохранить
              </button>
              <button type="button" className="btn btn-outline-secondary" disabled={saving} onClick={() => dispatch(resetDraft())}>
                Отменить
              </button>
              <button type="button" className="btn btn-outline-dark" onClick={handleOpenReport}>
                Печатный отчёт
              </button>
            </div>
          </div>

          <h5>Билеты бронирования</h5>
          {booking.tickets.length === 0 ? (
            <div className="alert alert-secondary">Билетов нет</div>
          ) : (
            <div className="table-responsive">
              <table className="table table-bordered">
                <thead>
                  <tr>
                    <th>Номер билета</th>
                    <th>ФИО пользователя</th>
                    <th>Перевозчик</th>
                  </tr>
                </thead>
                <tbody>
                  {booking.tickets.map((ticket) => (
                    <tr key={ticket.id}>
                      <td>{ticket.id}</td>
                      <td>{ticket.userName}</td>
                      <td>{ticket.operatorName}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </>
      )}
    </div>
  );
}
