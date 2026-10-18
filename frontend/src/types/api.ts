export interface UpdateUserRequest {
  fullName: string;
  email: string;
  phoneNumber: string | null;
  roleId: number;
}

export interface UpdateBookingRequest {
  userId: number | null;
  statusId: number;
  totalAmount: string;
}

export interface ApiErrorResponse {
  message: string;
}
