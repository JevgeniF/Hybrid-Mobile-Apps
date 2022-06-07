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
    public sealed class EditCategoryViewModel : INotifyPropertyChanged
    {
        private bool _isVisibleError;
        private string _message;
        public Category Category { get; set; }

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

        public ICommand EditCommand => new Command(EditCategory);

        private async void EditCategory()
        {
            if (string.IsNullOrEmpty(Category.CategoryName))
            {
                ShowError("List Name can't be empty.");
            }
            else
            {
                var jwtToken = Settings.JwtToken;
                var response = await ApiCategories.PutCategoryAsync(Category, jwtToken);
                if (response.IsSuccessStatusCode)
                {
                    await Application.Current.MainPage.Navigation.PopAsync();
                }
                else
                {
                    ShowError("Internal server error.");
                }
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

        public ICommand DeleteCommand => new Command(DeleteCategory);

        private async void DeleteCategory()
        {
            var jwtToken = Settings.JwtToken;
            var response = await ApiCategories.DeleteCategoryAsync(Category.Id, jwtToken);
            if (response.IsSuccessStatusCode)
            {
                await Application.Current.MainPage.Navigation.PopAsync();
            }
            else
            {
                IsVisibleError = true;
                Message = "List is not empty. Delete Todos first.";
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;

        private void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}