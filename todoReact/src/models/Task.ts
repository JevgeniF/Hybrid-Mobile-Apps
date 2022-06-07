export class Task {
  id: string;
  taskName: string;
  taskSort: number = 0;
  createdDt: string;
  dueDt: string = null;
  isCompleted: boolean = false;
  isArchived: boolean = false;
  todoCategoryId: string;
  todoPriorityId: string;
  syncDt: string;
}
