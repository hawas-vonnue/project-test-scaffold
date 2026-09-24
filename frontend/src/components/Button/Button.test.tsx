import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom/vitest';
import Button from './Button';

describe('Button', () => {
  it('renders the given label', () => {
    render(<Button label="Continue" />);
    expect(screen.getByText('Continue')).toBeInTheDocument();
  });
});
