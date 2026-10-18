import { useEffect } from 'react';
import { useAppDispatch, useAppSelector } from '../store/hooks';
import {
  cancelDraft,
  fetchUsersData,
  saveUser,
  updateDraft,
} from '../store/slices/usersSlice';
import type { User, UserDraft } from '../types/models';

export default function UsersTab() {
  const dispatch = useAppDispatch();
  const { users, roles, drafts, loading, error, savingId, successId } = useAppSelector(
    (state) => state.users,
  );

  useEffect(() => {
    dispatch(fetchUsersData());
  }, [dispatch]);

  const handleSave = (user: User) => {
    const draft = drafts[user.id];
    if (!draft) {
      return;
    }
    dispatch(saveUser({ userId: user.id, draft }));
  };

  const handleDraftChange = (
    userId: number,
    field: keyof UserDraft,
    value: string | number,
  ) => {
    dispatch(updateDraft({ userId, field, value }));
  };

  if (loading) {
    return <div className="alert alert-info">Загрузка пользователей...</div>;
  }

  if (error && users.length === 0) {
    return <div className="alert alert-danger">{error}</div>;
  }

  if (users.length === 0) {
    return <div className="alert alert-secondary">Пользователи не найдены</div>;
  }

  return (
    <div>
      {error && <div className="alert alert-danger">{error}</div>}

      {users.map((user) => {
        const draft = drafts[user.id];
        if (!draft) {
          return null;
        }

        return (
          <div key={user.id} className="border rounded p-3 mb-3 bg-light">
            <div className="row g-3 align-items-end">
              <div className="col-md-3">
                <label className="form-label" htmlFor={`fullName-${user.id}`}>ФИО</label>
                <input
                  id={`fullName-${user.id}`}
                  className="form-control"
                  value={draft.fullName}
                  onChange={(e) => handleDraftChange(user.id, 'fullName', e.target.value)}
                />
              </div>
              <div className="col-md-3">
                <label className="form-label" htmlFor={`email-${user.id}`}>Email</label>
                <input
                  id={`email-${user.id}`}
                  type="email"
                  className="form-control"
                  value={draft.email}
                  onChange={(e) => handleDraftChange(user.id, 'email', e.target.value)}
                />
              </div>
              <div className="col-md-2">
                <label className="form-label" htmlFor={`phone-${user.id}`}>Телефон</label>
                <input
                  id={`phone-${user.id}`}
                  className="form-control"
                  value={draft.phoneNumber}
                  onChange={(e) => handleDraftChange(user.id, 'phoneNumber', e.target.value)}
                />
              </div>
              <div className="col-md-2">
                <label className="form-label" htmlFor={`role-${user.id}`}>Роль</label>
                <select
                  id={`role-${user.id}`}
                  className="form-select"
                  value={draft.roleId}
                  onChange={(e) => handleDraftChange(user.id, 'roleId', e.target.value)}
                >
                  {roles.map((role) => (
                    <option key={role.id} value={role.id}>{role.name}</option>
                  ))}
                </select>
              </div>
              <div className="col-md-2 d-flex gap-2">
                <button
                  type="button"
                  className="btn btn-primary"
                  disabled={savingId === user.id}
                  onClick={() => handleSave(user)}
                >
                  Сохранить
                </button>
                <button
                  type="button"
                  className="btn btn-outline-secondary"
                  disabled={savingId === user.id}
                  onClick={() => dispatch(cancelDraft(user))}
                >
                  Отменить
                </button>
              </div>
            </div>
            {successId === user.id && (
              <div className="text-success mt-2">Изменения сохранены</div>
            )}
          </div>
        );
      })}
    </div>
  );
}
