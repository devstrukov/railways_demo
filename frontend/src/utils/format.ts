export function formatDate(value: string | null | undefined, style: 'short' | 'long' = 'short'): string {
  if (!value) {
    return '';
  }
  return new Intl.DateTimeFormat('ru-RU', {
    dateStyle: style,
    timeStyle: 'short',
  }).format(new Date(value));
}

export function formatAmount(value: number | string | null | undefined): string {
  if (value == null) {
    return '';
  }
  return Number(value).toLocaleString('ru-RU', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  });
}
