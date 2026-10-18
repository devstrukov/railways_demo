import { useEffect } from 'react';
import { useAppDispatch, useAppSelector } from '../store/hooks';
import { clearReport, fetchReportBooking } from '../store/slices/bookingDetailSlice';
import { formatAmount, formatDate } from '../utils/format';

interface PrintReportProps {
  bookingId: number;
  onBack: () => void;
}

export default function PrintReport({ bookingId, onBack }: PrintReportProps) {
  const dispatch = useAppDispatch();
  const { reportBooking, reportLoading, reportError } = useAppSelector(
    (state) => state.bookingDetail,
  );

  useEffect(() => {
    dispatch(fetchReportBooking(bookingId));
    return () => {
      dispatch(clearReport());
    };
  }, [dispatch, bookingId]);

  if (reportLoading) {
    return (
      <div className="container py-4">
        <div className="alert alert-info">Загрузка отчёта...</div>
      </div>
    );
  }

  if (reportError) {
    return (
      <div className="container py-4">
        <div className="alert alert-danger">{reportError}</div>
        <button type="button" className="btn btn-secondary no-print" onClick={onBack}>
          Назад
        </button>
      </div>
    );
  }

  if (!reportBooking) {
    return null;
  }

  return (
    <div className="print-page container py-4">
      <div className="d-flex gap-2 mb-3 no-print">
        <button type="button" className="btn btn-primary" onClick={() => window.print()}>
          Печать
        </button>
        <button type="button" className="btn btn-secondary" onClick={onBack}>
          Назад
        </button>
      </div>

      <div className="print-content">
        <h2 className="text-center mb-4">Отчёт по бронированию</h2>

        <div className="report-block border p-3 mb-4">
          <h4>Бронирование № {reportBooking.id}</h4>
          <p><strong>Пользователь:</strong> {reportBooking.userName || 'Не указан'}</p>
          <p><strong>Статус:</strong> {reportBooking.statusName}</p>
          <p><strong>Сумма:</strong> {formatAmount(reportBooking.totalAmount)}</p>
          <p><strong>Дата бронирования:</strong> {formatDate(reportBooking.bookingTime, 'long')}</p>

          <h5 className="mt-4">Билеты бронирования</h5>
          {reportBooking.tickets.length === 0 ? (
            <p>Билетов нет</p>
          ) : (
            <table className="table table-bordered report-table">
              <thead>
                <tr>
                  <th>Номер билета</th>
                  <th>ФИО пользователя</th>
                  <th>Перевозчик</th>
                </tr>
              </thead>
              <tbody>
                {reportBooking.tickets.map((ticket) => (
                  <tr key={ticket.id}>
                    <td>{ticket.id}</td>
                    <td>{ticket.userName}</td>
                    <td>{ticket.operatorName}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </div>
  );
}
