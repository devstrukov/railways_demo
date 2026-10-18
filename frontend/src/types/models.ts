export interface User {
  id: number;
  fullName: string;
  email: string;
  phoneNumber: string | null;
  roleId: number;
  roleName: string;
}

export interface Role {
  id: number;
  name: string;
}

export interface BookingStatus {
  id: number;
  name: string;
}

export interface Ticket {
  id: number;
  userName: string;
  operatorName: string;
}

export interface BookingListItem {
  id: number;
  userId: number | null;
  userName: string | null;
  statusId: number;
  statusName: string;
  totalAmount: number | string;
  bookingTime: string;
}

export interface BookingDetail extends BookingListItem {
  tickets: Ticket[];
}

export interface UserDraft {
  fullName: string;
  email: string;
  phoneNumber: string;
  roleId: number;
}

export interface BookingDraft {
  userId: number | '';
  statusId: number;
  totalAmount: string;
}

export type TabId = 'users' | 'bookings' | 'detail';
