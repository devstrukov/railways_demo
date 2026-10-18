import { createAsyncThunk, createSlice, type PayloadAction } from '@reduxjs/toolkit';
import type { Role, User, UserDraft } from '../../types/models';
import { api } from '../../utils/api';
import { createUserDraft } from '../../utils/drafts';

interface UsersState {
  users: User[];
  roles: Role[];
  drafts: Record<number, UserDraft>;
  loading: boolean;
  error: string | null;
  savingId: number | null;
  successId: number | null;
}

const initialState: UsersState = {
  users: [],
  roles: [],
  drafts: {},
  loading: false,
  error: null,
  savingId: null,
  successId: null,
};

export const fetchUsersData = createAsyncThunk('users/fetchUsersData', async () => {
  const [users, roles] = await Promise.all([api.getUsers(), api.getRoles()]);
  return { users, roles };
});

export const saveUser = createAsyncThunk(
  'users/saveUser',
  async ({ userId, draft }: { userId: number; draft: UserDraft }) => {
    const updated = await api.updateUser(userId, {
      fullName: draft.fullName,
      email: draft.email,
      phoneNumber: draft.phoneNumber || null,
      roleId: Number(draft.roleId),
    });
    return updated;
  },
);

const usersSlice = createSlice({
  name: 'users',
  initialState,
  reducers: {
    updateDraft(
      state,
      action: PayloadAction<{ userId: number; field: keyof UserDraft; value: string | number }>,
    ) {
      const { userId, field, value } = action.payload;
      const draft = state.drafts[userId];
      if (draft) {
        if (field === 'roleId') {
          draft.roleId = Number(value);
        } else {
          draft[field] = String(value);
        }
      }
      state.successId = null;
    },
    cancelDraft(state, action: PayloadAction<User>) {
      state.drafts[action.payload.id] = createUserDraft(action.payload);
      state.successId = null;
    },
    clearUserError(state) {
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchUsersData.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchUsersData.fulfilled, (state, action) => {
        state.loading = false;
        state.users = action.payload.users;
        state.roles = action.payload.roles;
        const drafts: Record<number, UserDraft> = {};
        action.payload.users.forEach((user) => {
          drafts[user.id] = createUserDraft(user);
        });
        state.drafts = drafts;
      })
      .addCase(fetchUsersData.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message ?? 'Ошибка загрузки пользователей';
      })
      .addCase(saveUser.pending, (state, action) => {
        state.savingId = action.meta.arg.userId;
        state.error = null;
        state.successId = null;
      })
      .addCase(saveUser.fulfilled, (state, action) => {
        state.savingId = null;
        state.users = state.users.map((item) =>
          item.id === action.payload.id ? action.payload : item,
        );
        state.drafts[action.payload.id] = createUserDraft(action.payload);
        state.successId = action.payload.id;
      })
      .addCase(saveUser.rejected, (state, action) => {
        state.savingId = null;
        state.error = action.error.message ?? 'Ошибка сохранения';
      });
  },
});

export const { updateDraft, cancelDraft, clearUserError } = usersSlice.actions;
export default usersSlice.reducer;
