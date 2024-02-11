export function randomString(): string {
  // eslint-disable-next-line @typescript-eslint/no-magic-numbers
  return Math.random().toString(36).slice(2);
}
