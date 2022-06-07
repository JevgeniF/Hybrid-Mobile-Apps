using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows.Input;
using Todorin.Helpers;
using Todorin.Models;
using Todorin.Services;
using Xamarin.Forms;

namespace Todorin.ViewModels
{
    public sealed class EditTaskViewModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        private void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        private bool _isVisibleError;
        private string _message;
        
        public Task Task { get; set; }
        
        public string Message
        {
            get => _message;
            set
            {
                _message = value;
                OnPropertyChanged();
            }
        }

        public bool IsVisibleError
        {
            get => _isVisibleError;
            set
            {
                _isVisibleError = value;
                OnPropertyChanged();
            }
        }
        
        public List<Priority> Priorities { get; set; }
        public List<Category> Categories { get; set; }
        
        private Category _selectedCategory;
        public Category SelectedCategory
        {
            get => _selectedCategory;
            set
            {
                _selectedCategory = value;
                OnPropertyChanged();
            }
        }
        
        private Priority _selectedPriority;
        public Priority SelectedPriority
        {
            get => _selectedPriority;
            set
            {
                _selectedPriority = value;
                OnPropertyChanged();
            }
        }

        public ICommand EditCommand => new Command(EditTask);

        private async void EditTask()
        {
            if (string.IsNullOrEmpty(Task.TaskName))
            {
                ShowError("Task name can't be empty.");
            }
            else if (string.IsNullOrEmpty(SelectedCategory.Id))
            {
                ShowError("Please select todo list.");
            }
            else if (string.IsNullOrEmpty(SelectedPriority.Id))
            {
                ShowError("Please select priority.");
            }
            else
            {
                Task.TodoCategoryId = SelectedCategory.Id;
                Task.TodoPriorityId = SelectedPriority.Id;
            }

            var response = await ApiTasks.PutTaskAsync(Task, Settings.JwtToken);
            if (response.IsSuccessStatusCode)
            {
                await Application.Current.MainPage.Navigation.PopAsync();
            }
            else
            {
                ShowError("Internal server error.");
            }
        }
        
        private void ShowError(string message)
        {
            Message = message;
            IsVisibleError = true;
            Device.StartTimer(TimeSpan.FromSeconds(3), () => {IsVisibleError = false;
                return false;
            });
        }
    }
}