using System;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text.RegularExpressions;
using System.Windows.Input;
using Newtonsoft.Json;
using Todorin.Helpers;
using Todorin.Models;
using Todorin.Services;
using Todorin.Views;
using Xamarin.Forms;

namespace Todorin.ViewModels
{
    public sealed class SignUpViewModel : INotifyPropertyChanged
    {
        private bool _isVisibleError;
        private string _message;
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }

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

        public ICommand SignUpCommand => new Command(SignUp);

        public event PropertyChangedEventHandler PropertyChanged;

        private async void SignUp()
        {
            if (string.IsNullOrEmpty(FirstName))
            {
                ShowError("First Name must contain at least one letter.");
            }
            else if (string.IsNullOrEmpty(LastName))
            {
                ShowError("Last Name Must contain at least one letter.");
            }
            else if (string.IsNullOrEmpty(Email) || !Regex.IsMatch(Email, Constants.RegexEmailPattern))
            {
                ShowError("Email has not valid pattern.");
            }
            else if (string.IsNullOrEmpty(Password) || !Regex.IsMatch(Password, Constants.RegexPasswordPattern))
            {
                ShowError("Password must have at least 6 chars: 1 uppercase, 1 number, 1 special.");
            }
            else
            {
                var response = await ApiAuthentication.SignUpAsync(FirstName, LastName, Email, Password);
                var content = await response.Content.ReadAsStringAsync();

                if (response.IsSuccessStatusCode)
                {
                    Settings.FirstName = FirstName;
                    Settings.LastName = LastName;
                    Settings.Email = Email;
                    var contentDynamic = JsonConvert.DeserializeObject<User>(content);

                    if (contentDynamic == null) return;
                    var jwtToken = contentDynamic.Token;
                    Settings.JwtToken = jwtToken;
                    
                    var normal = new Priority
                    {
                        PriorityName = "Normal"
                    };
                    await ApiPriorities.PostPriorityAsync(normal, Settings.JwtToken);
                    
                    var important = new Priority
                    {
                        PriorityName = "Important",
                        PrioritySort = 1
                    };
                    await ApiPriorities.PostPriorityAsync(important, Settings.JwtToken);

                    var category = new Category
                    {
                        CategoryName = "Default"
                    };
                    await ApiCategories.PostCategoryAsync(category, jwtToken);
                    await Application.Current.MainPage.Navigation.PushAsync(new CategoriesPage());
                }
                else
                {
                    var contentDynamic = JsonConvert.DeserializeObject<ErrorMessages>(content);
                    if (contentDynamic == null) return;
                    IsVisibleError = true;
                    Message = contentDynamic.ToString();
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

        private void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}