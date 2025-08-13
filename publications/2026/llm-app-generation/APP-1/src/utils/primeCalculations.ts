// Placeholder for prime calculation functions
const isPrime = (n: number): boolean => {
  if (n <= 1) {
    return false;
  }
  for (let i = 2; i * i <= n; i++) {
    if (n % i === 0) {
      return false;
    }
  }
  return true;
};

export { isPrime };
const findPrimesInRange = (start: number, end: number): number[] => {
  const primes = [];
  for (let i = start; i <= end; i++) {
    if (isPrime(i)) {
      primes.push(i);
    }
  }
  return primes;
};

export { findPrimesInRange };
const findNextPrime = (n: number): number => {
  let next = n + 1;
  while (true) {
    if (isPrime(next)) {
      return next;
    }
    next++;
  }
};

export { findNextPrime };