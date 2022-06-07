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
    public sealed class AddNewCategoryViewModel : INotifyPropertyChanged
    {
        private bool _isVisibleError;
        private string _message;
        public string CategoryName { get; set; }

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

        public ICommand AddCommand => new Command(AddCategory);

        private async void AddCategory()
        {
            if (string.IsNullOrEmpty(CategoryName))
            {
                ShowError("List name can't be empty.");
            }
            else
            {
                var category = new Category {CategoryName = CategoryName};

                var jwtToken = Settings.JwtToken;
                var response = await ApiCategories.PostCategoryAsync(category, jwtToken);
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

        public event PropertyChangedEventHandler PropertyChanged;

        private void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}