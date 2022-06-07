using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Windows.Input;
using Todorin.Helpers;
using Todorin.Models;
using Todorin.Services;
using Todorin.Views;
using Xamarin.Forms;

namespace Todorin.ViewModels
{
    public class CategoriesViewModel : INotifyPropertyChanged
    {
        private ObservableCollection<Task> _tasks;
        private ObservableCollection<Category> _categories;
        private int _tasksCount;

        public int TasksCount
        {
            get => _tasksCount;
            set
            {
                _tasksCount = value;
                OnPropertyChanged();
            }
        }

        public CategoriesViewModel()
        {
            GetCategories();
        }

        public ObservableCollection<Category> Categories
        {
            get => _categories;
            set
            {
                _categories = value;
                OnPropertyChanged();
            }
        }

        private string _message;

        public string Message
        {
            get => _message;
            set
            {
                _message = value;
                OnPropertyChanged();
            }
        }

        private bool _isVisibleError;
        public bool IsVisibleError
        {
            get => _isVisibleError;
            set
            {
                _isVisibleError = value;
                OnPropertyChanged();
            }
        }
        
        public ObservableCollection<Task> Tasks
        {
            get => _tasks;
            set
            {
                _tasks = value;
                OnPropertyChanged();
            }
        }

        public ICommand GetCategoriesCommand => new Command(GetCategories);

        public ICommand SettingsCommand => new Command(GoToSettings);

        public void ShowError(string message)
        {
            Message = message;
            IsVisibleError = true;
            Device.StartTimer(TimeSpan.FromSeconds(3), () => {IsVisibleError = false;
                return false;
            });
        }

        public async void GetCategories()
        {
            var jwtToken = Settings.JwtToken;
            var categories = await ApiCategories.GetCategoriesAsync(jwtToken);
            Tasks = await ApiTasks.GetTasksAsync(jwtToken);
            TasksCount = Tasks.Count;
            foreach (var category in categories)
            {
                category.TasksCount = Tasks.Count(task => task.TodoCategoryId == category.Id);
            }

            Categories = categories;
        }

        private async void GoToSettings()
        {
            await Application.Current.MainPage.Navigation.PushAsync(new SettingsPage());
        }

        public event PropertyChangedEventHandler PropertyChanged;
        private void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}