export interface Day {
  id: string;
  courseId: string;
  dayNumber: number;
  title: string;
  status: 'locked' | 'current' | 'done';
}
