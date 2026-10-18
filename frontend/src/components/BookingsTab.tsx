import { useEffect } from 'react';
import { useAppDispatch, useAppSelector } from '../store/hooks';
import { fetchBookings } from '../store/slices/bookingsSlice';
import { formatAmount, formatDate } from '../utils/format';

interface BookingsTabProps {
  onOpen: (bookingId: number) => void;
}

export default function BookingsTab({ onOpen }: BookingsTabProps) {
  const dispatch = useAppDispatch();
  const { items, loading, error } = useAppSelector((state) => state.bookings);

  useEffect(() => {
    dispatch(fetchBookings());
  }, [dispatch]);

  if (loading) {
    return <div className="alert alert-info">Загрузка бронирований...</div>;
  }

  if (error) {
    return <div className="alert alert-danger">{error}</div>;
  }

  if (items.length === 0) {
    return <div className="alert alert-secondary">Бронирования не найдены</div>;
  }

  return (
    <div className="table-responsive">
      <table className="table table-striped table-bordered align-middle">
        <thead>
          <tr>
            <th>Номер бронирования</th>
            <th>Пользователь</th>
            <th>Статус</th>
            <th>Сумма</th>
            <th>Дата</th>
            <th>Действие</th>
          </tr>
        </thead>
        <tbody>
          {items.map((booking) => (
            <tr key={booking.id}>
              <td>{booking.id}</td>
              <td>{booking.userName || 'Не указан'}</td>
              <td>{booking.statusName}</td>
              <td>{formatAmount(booking.totalAmount)}</td>
              <td>{formatDate(booking.bookingTime)}</td>
              <td>
                <button
                  type="button"
                  className="btn btn-sm btn-outline-primary"
                  onClick={() => onOpen(booking.id)}
                >
                  Открыть
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
