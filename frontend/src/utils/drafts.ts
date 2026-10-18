import type {
  BookingDetail,
  BookingDraft,
  BookingListItem,
  User,
  UserDraft,
} from '../types/models';

export function createUserDraft(user: User): UserDraft {
  return {
    fullName: user.fullName || '',
    email: user.email || '',
    phoneNumber: user.phoneNumber || '',
    roleId: user.roleId,
  };
}

export function createBookingDraft(booking: BookingDetail | BookingListItem): BookingDraft {
  return {
    userId: booking.userId ?? '',
    statusId: booking.statusId,
    totalAmount: booking.totalAmount != null ? String(booking.totalAmount) : '',
  };
}

export function bookingDraftsEqual(a: BookingDraft, b: BookingDraft): boolean {
  return a.userId === b.userId
    && String(a.statusId) === String(b.statusId)
    && a.totalAmount === b.totalAmount;
}
