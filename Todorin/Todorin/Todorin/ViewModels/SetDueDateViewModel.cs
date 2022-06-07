using System;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows.Input;
using Todorin.Helpers;
using Todorin.Models;
using Todorin.Services;
using Xamarin.Forms;

namespace Todorin.ViewModels
{
    public sealed class SetDueDateViewModel : INotifyPropertyChanged
    {
        public SetDueDateViewModel()
        {
            MinDateTime = DateTime.Now;
            MaxDateTime = DateTime.Now.AddYears(3);
            SelectedDate = MinDateTime;
            SelectedTime = MinDateTime.TimeOfDay;
        }
        
        public Task CTask;
        private TimeSpan _selectedTime;
        public TimeSpan SelectedTime
        {
            get => _selectedTime;
            set
            {
                _selectedTime = value;
                OnPropertyChanged();
            }
        }

        public DateTime MinDateTime { get; set; }
        public DateTime MaxDateTime { get; set; }

        private DateTime _selectedDate;

        public DateTime SelectedDate
        {
            get => _selectedDate;
            set
            {
                _selectedDate = value;
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
        
        public ICommand SetDate => new Command(SetDueDate);

        private async void SetDueDate()
        {
            var dateTime = SelectedDate.Date.Add(SelectedTime).ToUniversalTime().ToString("o");
            CTask.DueDt = dateTime;

            var response = await ApiTasks.PutTaskAsync(CTask, Settings.JwtToken);
            if (response.IsSuccessStatusCode)
            {
                await Application.Current.MainPage.Navigation.PopAsync();
            }
            else
            {
                ShowError("Internal Server Error.");
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

        public event PropertyChangedEventHandler PropertyChanged;

        private void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}