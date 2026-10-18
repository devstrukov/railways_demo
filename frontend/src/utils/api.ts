import type { UpdateBookingRequest, UpdateUserRequest, ApiErrorResponse } from '../types/api';
import type {
  BookingDetail,
  BookingListItem,
  BookingStatus,
  Role,
  User,
} from '../types/models';

async function request<T>(url: string, options: RequestInit = {}): Promise<T> {
  const response = await fetch(url, {
    headers: {
      'Content-Type': 'application/json',
      ...(options.headers ?? {}),
    },
    ...options,
  });

  if (!response.ok) {
    let message = 'Ошибка запроса';
    try {
      const data = (await response.json()) as ApiErrorResponse;
      if (data.message) {
        message = data.message;
      }
    } catch {
      // ignore parse errors
    }
    throw new Error(message);
  }

  if (response.status === 204) {
    return null as T;
  }

  return response.json() as Promise<T>;
}

export const api = {
  getUsers: (): Promise<User[]> => request('/api/users'),
  updateUser: (id: number, body: UpdateUserRequest): Promise<User> =>
    request(`/api/users/${id}`, { method: 'PUT', body: JSON.stringify(body) }),
  getRoles: (): Promise<Role[]> => request('/api/roles'),
  getBookingStatuses: (): Promise<BookingStatus[]> => request('/api/booking-statuses'),
  getBookings: (): Promise<BookingListItem[]> => request('/api/bookings'),
  getBooking: (id: number): Promise<BookingDetail> => request(`/api/bookings/${id}`),
  updateBooking: (id: number, body: UpdateBookingRequest): Promise<BookingDetail> =>
    request(`/api/bookings/${id}`, { method: 'PUT', body: JSON.stringify(body) }),
};
