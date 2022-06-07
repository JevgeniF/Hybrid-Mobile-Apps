using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Windows.Input;
using Todorin.Helpers;
using Todorin.Models;
using Todorin.Services;
using Xamarin.Forms;

namespace Todorin.ViewModels
{
    public sealed class TasksViewModel : INotifyPropertyChanged
    {
        public Category Category { get; set; }
        private ObservableCollection<Task> _tasks;
        public List<Priority> Priorities { get; set; }
        public ObservableCollection<Category> Categories { get; set; }

        public ObservableCollection<Task> Tasks
        {
            get => _tasks;
            set
            {
                _tasks = value;
                OnPropertyChanged();
            }
        }

        public TasksViewModel()
        {
            GetTasks();
        }

        public ICommand GetTasksCommand => new Command(GetTasks);

        public async void GetTasks()
        {
            var jwtToken = Settings.JwtToken;
            var tasks = await ApiTasks.GetTasksAsync(jwtToken);
            tasks = Category.Id != null ? 
                new ObservableCollection<Task>(tasks.Where(task => task.TodoCategoryId == Category.Id)) : tasks;
            GetCategories();
            GetPriorities();
            SetAdditionalProperties(tasks);
            Tasks = tasks;
            
            SortTasks();
        }

        public void SortTasks()
        {
            var active = Tasks.Where(task => !task.IsCompleted).ToList();
            var completed = Tasks.Where(task => task.IsCompleted).ToList();
            switch (Settings.SortingMode)
            {
                case 0:
                    active = active.OrderBy(task => task.TodoPriorityId)
                        .ThenBy(task => task.TaskName).ToList();
                    completed = completed.OrderBy(task => task.TodoPriorityId)
                        .ThenBy(task => task.TaskName).ToList();
                    active.AddRange(completed);
                    Tasks = new ObservableCollection<Task>(active);
                    break;
                case 1:
                    active = active.OrderBy(task => task.TaskName).ToList();
                    completed = completed.OrderBy(task => task.TaskName).ToList();
                    active.AddRange(completed);
                    Tasks = new ObservableCollection<Task>(active);
                    break;
                case 2:
                    active = active.OrderBy(task => task.TodoPriorityId).ToList();
                    completed = completed.OrderBy(task => task.TodoPriorityId).ToList();
                    active.AddRange(completed);
                    Tasks = new ObservableCollection<Task>(active);
                    break;
                case 3:
                    active = active.OrderByDescending(task => task.TodoPriorityId).ToList();
                    completed = completed.OrderByDescending(task => task.TodoPriorityId).ToList();
                    active.AddRange(completed);
                    Tasks = new ObservableCollection<Task>(active);
                    break;
                case 4:
                {
                    var nonNullActive = active.Where(task => !string.IsNullOrEmpty(task.DueDt)).ToList();
                    var nullActive = active.Where(task => string.IsNullOrEmpty(task.DueDt)).ToList();
                    nonNullActive = nonNullActive.OrderBy(task => task.DueDt).ToList();
                    nonNullActive.AddRange(nullActive);
                    
                    var nonNullCompleted = completed.Where(task => !string.IsNullOrEmpty(task.DueDt)).ToList();
                    var nullCompleted = completed.Where(task => string.IsNullOrEmpty(task.DueDt)).ToList();
                    nonNullCompleted = nonNullCompleted.OrderBy(task => task.DueDt).ToList();
                    nonNullCompleted.AddRange(nullCompleted);
                    
                    nonNullActive.AddRange(nonNullCompleted);
                    Tasks = new ObservableCollection<Task>(nonNullActive);
                    break;
                }
            }
        }

        private void SetAdditionalProperties(ObservableCollection<Task> tasks)
        {
            foreach (var task in tasks)
            {
                if (task.IsCompleted) task.TextDecorations = TextDecorations.Strikethrough;

                if (Categories == null) continue;
                foreach (var category in Categories.Where(category => task.TodoCategoryId == category.Id))
                {
                    task.CategoryName = category.CategoryName;
                }

                foreach (var priority in Priorities.Where(priority => task.TodoPriorityId == priority.Id))
                {
                    task.PriorityName = priority.PriorityName;
                    task.PriorityIcon = ImageSource.FromFile(task.PriorityName == "Important"
                        ? "star_yellow.png"
                        : "star_outlined.png");
                }

                if (task.DueDt != null)
                    task.NormalizedDate = DateTime
                        .Parse(task.DueDt).ToLocalTime()
                        .ToString("dd.MM.yy\nHH:mm");
                else task.NormalizedDate = "Set due\ndate";
            }
        }

        public async void GetCategories()
        {
            var jwtToken = Settings.JwtToken;
            var categories = await ApiCategories.GetCategoriesAsync(jwtToken);
            Categories = categories;
        }

        public async void GetPriorities()
        {
            var jwtToken = Settings.JwtToken;
            var priorities = await ApiPriorities.GetPrioritiesAsync(jwtToken);
            Priorities = priorities;
        }
        

        

        public event PropertyChangedEventHandler PropertyChanged;

        private void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}